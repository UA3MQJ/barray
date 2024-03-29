use rustler::{Encoder, Env, Error, Term};

mod atoms {
    rustler::rustler_atoms! {
        atom ok;
        atom error;
        atom __true__ = "true";
        atom __false__ = "false";
    }
}

rustler::rustler_export_nifs! {
    "Elixir.RUtils",
    [
        ("add", 2, add)
    ],
    None
}

fn add<'a>(env: Env<'a>, args: &[Term<'a>]) -> Result<Term<'a>, Error> {
    let num1: i64 = args[0].decode()?;
    let num2: i64 = args[1].decode()?;

    if num2==100 {
      // err
      return Ok(atoms::ok().encode(env))
    }

    Ok((atoms::ok(), num1 + num2).encode(env))
}
