#include <erl_nif.h>
#include <string.h>
#include <memory>

static ERL_NIF_TERM
make_binary(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[])
{
    ErlNifBinary bin;
    ErlNifUInt64 i, size;

    enif_get_uint64(env, argv[0], &size);
    enif_alloc_binary(size, &bin);

    // set 0 to all elements
    // memset(bin.data, 0, size);

    return enif_make_binary(env, &bin);
}

static ERL_NIF_TERM
dirty_update_binary(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[])
{
    ErlNifBinary data, element;
    ErlNifSInt64 i;
    int64_t i_start;
    int64_t i_end;

    if (!enif_inspect_binary(env, argv[0], &data)) {
        return enif_make_badarg(env);
    }

    if (!enif_inspect_binary(env, argv[1], &element)) {
        return enif_make_badarg(env);
    }

    enif_get_int64(env, argv[2], &i);

    i_start = i * element.size;
    i_end = i_start + element.size;

    if ((i_start<0)||(i_start>=data.size)||(i_end>data.size)) {
        return enif_make_badarg(env);
    }

    // data.data[0] = 66;
    memcpy(data.data + i_start, element.data, element.size);

    // return enif_make_binary(env, &data);
    return enif_make_atom(env, "ok");
}

static ERL_NIF_TERM
update_binary(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[])
{
    ErlNifBinary data, element, new_data;
    ErlNifSInt64 i;
    int64_t i_start;
    int64_t i_end;

    if (!enif_inspect_binary(env, argv[0], &data)) {
        return enif_make_badarg(env);
    }

    if (!enif_inspect_binary(env, argv[1], &element)) {
        return enif_make_badarg(env);
    }

    enif_get_int64(env, argv[2], &i);

    i_start = i * element.size;
    i_end = i_start + element.size;

    if ((i_start<0)||(i_start>=data.size)||(i_end>data.size)) {
        return enif_make_badarg(env);
    }

    enif_alloc_binary(data.size, &new_data);
    memcpy(new_data.data, data.data, data.size);
    memcpy(new_data.data + i_start, element.data, element.size);

    return enif_make_binary(env, &new_data);
}

static ERL_NIF_TERM
get_sub_binary(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[])
{
    ErlNifBinary data, sub_data;
    ErlNifSInt64 i, el_size;
    int64_t i_start;
    int64_t i_end;

    if (!enif_inspect_binary(env, argv[0], &data)) {
        return enif_make_badarg(env);
    }

    enif_get_int64(env, argv[1], &el_size);
    enif_get_int64(env, argv[2], &i);

    i_start = i * el_size;
    i_end = i_start + el_size;

    if ((i_start<0)||(i_start>=data.size)||(i_end>data.size)) {
        return enif_make_badarg(env);
    }

    // enif_alloc_binary(el_size, &sub_data);
    // memcpy(sub_data.data, data.data + i_start, el_size);
    // return enif_make_binary(env, &sub_data);
    
    return enif_make_sub_binary(env, argv[0], i_start, el_size);
}

static ErlNifResourceType* array_type = NULL;

typedef struct {
  uint32_t length;
  uint32_t width;
//   uint8_t* items;
} Array;

static ERL_NIF_TERM
res_make(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[]) {

    long res_length; //4 байта (32 бита)
    long res_width; 

    if (!enif_get_long(env, argv[0], &res_length))
        return enif_make_badarg(env);

    if (!enif_get_long(env, argv[1], &res_width))
        return enif_make_badarg(env);
    
    Array* array = static_cast<Array *>(enif_alloc_resource(array_type, sizeof(Array)));

    array->length = res_length;
    array->width  = res_width;

    ERL_NIF_TERM term = enif_make_resource(env, array);

    enif_release_resource(array); 

    return term;
}

static ERL_NIF_TERM
res_length(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[]) {
    Array* array;

    if(!enif_get_resource(env, argv[0], array_type, (void **) &array)) {
        return enif_make_badarg(env);
    }

    ERL_NIF_TERM term = enif_make_long(env, array->length);

    return term;
}


static void destruct_array(ErlNifEnv *env, void *arg) {
    printf("\n\rDestructing array: %p", arg);
    // Array* array = (Array*) arg;
    // if (array && array->length && array->items) {
    //     free(array->items);
    //     array->items = 0;
    // }
}

/*
 * Load the nif. Initialize some stuff and such
 */
static int on_load(ErlNifEnv* env, void** priv, ERL_NIF_TERM info) {
    ErlNifResourceType* rt = enif_open_resource_type(env, "tuple_nif", "array_type", destruct_array, ERL_NIF_RT_CREATE, NULL);
    if(!rt) return -1;
    array_type = rt;
    return 0;
}

static int on_reload(ErlNifEnv* env, void** priv_data, ERL_NIF_TERM load_info)
{
    return 0;
}

static int on_upgrade(ErlNifEnv* env, void** priv, void** old_priv_data, ERL_NIF_TERM load_info)
{
    return 0;
}

static ErlNifFunc nif_funcs[] = {
    {"make_binary", 1, make_binary},
    {"dirty_update_binary", 3, dirty_update_binary},
    {"update_binary", 3, update_binary},
    {"get_sub_binary", 3, get_sub_binary},
    {"res_make", 2, res_make},
    {"res_length", 1, res_length},
};

ERL_NIF_INIT(Elixir.UtilsNif, nif_funcs, on_load, on_reload, on_upgrade, NULL)
