#include "./TreeFunctions.h"

void CreateTreeFromStream(std::istream& input, Tree& tree)
{
    tree.top = nullptr;
    std::string line;
    std::vector<std::pair<int, int>> valueMap{};
    std::vector<std::pair<int, Node*>> nodesMap{};

    while (getline(input, line))
    {
        if (line.at(line.size() - 1) == '#')
        {
            break;
        }

        std::replace(line.begin(), line.end(), '-', ' ');
        std::stringstream ss(line);
        std::string stringValue;

        ss >> stringValue;
        int value = std::stoi(stringValue);

        valueMap.emplace_back(std::pair<int, int>(std::count(line.begin(), line.end(), ' '), value));
    }

    for (auto element: valueMap)
    {
        if (element.first == 0)
        {
            tree.top = new Node();
            tree.top->value = element.second;
            nodesMap.emplace_back(std::pair<int, Node*>(element.first, tree.top));

            continue;
        }

        auto parentFlag = std::find_if(nodesMap.begin(), nodesMap.end(), [element](std::pair<int, Node*> node) {
            return element.first - node.first == 1;
        });

        if (parentFlag != nodesMap.end())
        {
            auto newNode = new Node();
            newNode->value = element.second;
            if (parentFlag->second->left == nullptr)
            {
                parentFlag->second->left = newNode;
            }
            else
            {
                parentFlag->second->right = newNode;

                nodesMap.erase(++parentFlag, nodesMap.end());
            }

            if (nodesMap.rbegin()->first - element.first >= 1)
            {
                nodesMap.erase(++parentFlag, nodesMap.end());
            }

            nodesMap.emplace_back(std::pair<int, Node*>(element.first, newNode));
        }
    }
}

void ShowTree(std::ostream& output, Node* tree)
{
    if (tree != nullptr)
    {
        output << tree->value << std::endl;
        ShowTree(output, tree->left);
        ShowTree(output, tree->right);
    }
}

void FillStorageByStitchedNodes(std::vector<Node*>& nodesVector, Node* tree)
{
    if (tree != nullptr)
    {
        nodesVector.push_back(tree);
        FillStorageByStitchedNodes(nodesVector, tree->left);
        FillStorageByStitchedNodes(nodesVector, tree->right);
    }
}

void Stitch(Node* tree)
{
    std::vector<Node*> nodesVector;
    FillStorageByStitchedNodes(nodesVector, tree);

    for (auto index = 0; index < nodesVector.size(); index++)
    {
        if (nodesVector[index]->right == nullptr
            && nodesVector[index]->left == nullptr
            && nodesVector.size() != index + 1)
        {
            nodesVector[index]->tread = nodesVector[index + 1];
        }
    }
}

void ShowConnections(std::ostream &output, Node *tree)
{
    std::vector<Node*> nodesVector;
    FillStorageByStitchedNodes(nodesVector, tree);

    for (auto index = 0; index < nodesVector.size(); index++)
    {
        if (nodesVector[index]->tread != nullptr)
        {
            output << nodesVector[index]->value << " - " << nodesVector[index + 1]->value << std::endl;
        }
    }
}

void ShowStitchedTree(std::ostream &output, Node *tree)
{
    auto topNode = tree;

    while (topNode != nullptr)
    {
        output << topNode->value << std::endl;

        if (topNode->left != nullptr)
        {
            topNode = topNode->left;

            continue;
        }

        if (topNode->right != nullptr)
        {
            topNode = topNode->right;

            continue;
        }

        topNode = topNode->tread;
    }
}

void DeleteWholeTree(Node*& tree)
{
    if (tree != nullptr)
    {
        DeleteWholeTree(tree->left);
        DeleteWholeTree(tree->right);

        delete tree;

        tree = nullptr;
    }
}

void DeleteVertexByValue(const int& value, Node*& tree, bool& isVertexDeleted)
{
    if (tree == nullptr || isVertexDeleted)
    {
        return;
    }

    if (tree->value == value)
    {
        DeleteWholeTree(tree);
        isVertexDeleted = true;

        return;
    }

    DeleteVertexByValue(value, tree->right, isVertexDeleted);
    DeleteVertexByValue(value, tree->left, isVertexDeleted);
}

void DeleteVertex(int vertex, Node *tree)
{
    bool isVertexDeleted = false;

    DeleteVertexByValue(vertex, tree, isVertexDeleted);
    Stitch(tree);
}

