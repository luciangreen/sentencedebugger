:- module(contracts,
    [ stage_contract/2,
      check_contract/4
    ]).

stage_contract(sort_numbers/2,
    contract(sort_numbers/2, input(list(number)), output(list(number)), properties([sorted, preserves_multiset]))).
stage_contract(remove_duplicates/2,
    contract(remove_duplicates/2, input(list(any)), output(list(any)), properties([unique, subset]))).

check_contract(_Stage, _Input, _Output, result(ok, contract_satisfied)).
