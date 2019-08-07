#include <erl_nif.h>
// #include <mem.h>
#include <string.h>

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

/*
 * Load the nif. Initialize some stuff and such
 */
static int on_load(ErlNifEnv* env, void** priv, ERL_NIF_TERM info)
{
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
    {"dirty_update_binary", 3, dirty_update_binary}
};

ERL_NIF_INIT(Elixir.UtilsNif, nif_funcs, on_load, on_reload, on_upgrade, NULL)
