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
}

static_error_tests! {
    {
        name: error3,
        file: "error3.snek",
        expected: ""
    },
}
