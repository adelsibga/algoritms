cmake_minimum_required(VERSION 3.20)
project(StitchedTreeFS)

set(CMAKE_CXX_STANDARD 20)

add_executable(StitchedTreeFS main.cpp lib/node/Node.h lib/tree/Tree.h lib/tree_functions/TreeFunctions.h lib/tree_functions/TreeFunctions.cpp)
