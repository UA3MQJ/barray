#include <erl_nif.h>
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
    {"make_binary", 1, make_binary}
};

ERL_NIF_INIT(Elixir.UtilsNif, nif_funcs, on_load, on_reload, on_upgrade, NULL)
