#pragma once

#include "sstream"
#include "functional"
#include "vector"
#include "./../tree/Tree.h"

void CreateTreeFromStream(std::istream& input, Tree& tree);

void ShowTree(std::ostream& output, Node* tree);

void Stitch(Node* tree);

void ShowStitchedTree(std::ostream& output, Node* tree);

void ShowConnections(std::ostream& output, Node* tree);

void DeleteVertex(int vertex, Node* tree);

void DeleteWholeTree(Node*& tree);