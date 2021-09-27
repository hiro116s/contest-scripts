set -eux

build_contest_library() {
    git clone git@github.com:hiro116s/heuristics-contest-library.git
    cd heuristics-contest-library
    ./gradlew jar
    cd ~
}

build_atcoder_library() {
    read -p "atcoder_library's branch name:" branch_name
    git clone git@github.com:hiro116s/atcoder_library.git
    cd atcoder_library
    git checkout $branch_name
    cd src/main/java
    javac Main.java
    cp ~/heuristics-contest-library/build/libs/heuristics-contest-library-1.0-SNAPSHOT.jar .
}

echo_simulation_script() {
    read -p "command template:" command_template
    read -p "seeds num:" max_seed
    read -p "num threads:" num_threads
    read -p "contest name:" contest_name
    read -p "s3 access (Y or N):" access_s3
    read -p "dynamodb access (Y or N):" access_dynamodb

    echo -n "java -cp java -cp ./heuristics-contest-library-1.0-SNAPSHOT.jar hiro116s.simulator.MarathonCodeSimulator --commandTemplate '$command_template' --minSeed 0 --maxSeed $max_seed --numThreads $num_threads --contestName $contest_name"
    if [[ $access_s3 == "Y" ]]; then
        echo -n " --s3"
    fi
    if [[ $access_dynamodb == "Y" ]]; then
        echo -n " --dynamo"
    fi
    echo
}

build_contest_library
build_atcoder_library
echo_simulation_script
