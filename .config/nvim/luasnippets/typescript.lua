---@diagnostic disable: undefined-global
return {
  snippet("usestate", {
    t "const [",
    i(1),
    t ", set",
    d(2, require_var, { 1 }),
    t "] = ",
    c(4, {
      t "React.useState(",
      t "useState(",
    }),
    i(3, "initialState"),
    t ")",
    i(0),
  }),
}
