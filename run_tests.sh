#!/bin/bash

failed=false

export PGPASSWORD=pass
PORT=${PGPORT:-5432}

mkdir -p results

for problem in sql/*; do
    printf "$problem "
    problem_id=$(basename ${problem%.sql})
    result="results/$problem_id.out"
    expected="expected/$problem_id.out"
    psql -h localhost -p $PORT -U postgres -d postgres < $problem > $result
    DIFF=$(diff -B $expected $result)
    if [ -z "$DIFF" ]; then
        echo pass
    else
        echo fail
        failed=true
    fi
done

if [ "$failed" = "true" ]; then
    exit 2
fi

