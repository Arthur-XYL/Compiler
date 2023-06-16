mod infra;

// Your tests go here!
success_tests! {
    {
        name: simple_examples,
        file: "simple_examples.snek",
        expected: "5",
    },
    {
        name: points,
        file: "points.snek",
        expected: "(tuple 4 10)\n(tuple 2 2)\n(tuple 6 12)\n(tuple 10 20)\n(tuple 10 20)\n",
    },
    {
        name: bst,
        file: "bst.snek",
        expected: "(tuple 10 (tuple 9 (tuple 6 nil nil) nil) (tuple 12 nil (tuple 21 (tuple 15 nil nil) nil)))",
    },
    {
        name: bst_1,
        file: "bst_1.snek",
        expected: "(tuple 8 nil (tuple 9 nil nil))\n(tuple 8 (tuple 7 nil nil) nil)\n(tuple 8 nil nil)\n(tuple 8 nil nil)",
    },
    {
        name: bst_2,
        file: "bst_2.snek",
        expected: "(tuple 1 nil (tuple 4 nil nil))\n(tuple 1 nil (tuple 4 (tuple 3 nil nil) nil))\n(tuple 1 nil (tuple 4 (tuple 3 (tuple 2 nil nil) nil) nil))\n(tuple 1 nil (tuple 4 (tuple 3 (tuple 2 nil nil) nil) nil))",
    },
    {
        name: bst_3,
        file: "bst_3.snek",
        expected: "(tuple 1 nil nil)",
    },
    {
        name: fact,
        file: "fact.snek",
        input: "10",
        expected: "3628800",
    },
    {
        name: even_odd_1,
        file: "even_odd.snek",
        input: "10",
        expected: "10\ntrue\ntrue",
    },
    {
        name: even_odd_2,
        file: "even_odd.snek",
        input: "9",
        expected: "9\nfalse\nfalse",
    },
    {
        name: fact_recursive,
        file: "fact_recursive.snek",
        input: "10",
        expected: "3628800"
    },
    {
        name: no_arg,
        file: "no_arg.snek",
        expected: "false\nfalse"
    },
    {
        name: no_funcall,
        file: "no_funcall.snek",
        input: "10",
        expected: "20"
    },
    {
        name: many_print,
        file: "many_print.snek",
        expected: "true\ntrue\n1\n1\n2\n3\n3\n4\n5\n6\n6\n6"
    },
    {
        name: fun_call_fun,
        file: "fun_call_fun.snek",
        expected: "1255728436324481025"
    },
}

runtime_error_tests! {
    {
        name: error_tag,
        file: "error_tag.snek",
        expected: ""
    },
    {
        name: error_bounds,
        file: "error_bounds.snek",
        expected: ""
    },
    {
        name: wrong_param_type,
        file: "wrong_param_type.snek",
        expected: ""
    },
}

static_error_tests! {
    {
        name: error3,
        file: "error3.snek",
        expected: ""
    },
    {
        name: duplicate_params,
        file: "duplicate_params.snek",
        expected: "",
    },
    {
        name: input_param,
        file: "input_param.snek",
        expected: ""
    },
    {
        name: wrong_param_num,
        file: "wrong_param_num.snek",
        expected: ""
    },
    {
        name: invalid_name,
        file: "invalid_name.snek",
        expected: ""
    },
    {
        name: fun_with_input,
        file: "fun_with_input.snek",
        expected: ""
    },

}
