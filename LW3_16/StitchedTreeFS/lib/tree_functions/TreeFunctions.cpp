#include "./TreeFunctions.h"

void CreateTreeFromStream(std::istream& input, Tree& tree)
{
    tree.top = nullptr;
    std::string line;
    std::vector<std::pair<int, int>> arrayOfNewNodesValues{};
    std::vector<std::pair<int, Node*>> arrayOfNewNodes{};

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

        arrayOfNewNodesValues.emplace_back(std::pair<int, int>(std::count(line.begin(), line.end(), ' '), value));
    }

    for (std::pair<int, int> element: arrayOfNewNodesValues)
    {
        if (element.first == 0)
        {
            tree.top = new Node();
            tree.top->value = element.second;
            arrayOfNewNodes.emplace_back(std::pair<int, Node*>(element.first, tree.top));

            continue;
        }

        auto parentFlag = std::find_if(arrayOfNewNodes.begin(), arrayOfNewNodes.end(), [element](std::pair<int, Node*> node) {
            return element.first - node.first == 1;
        });

        if (parentFlag != arrayOfNewNodes.end())
        {
            Node* node = new Node();

            node->value = element.second;

            if (parentFlag->second->left == nullptr)
            {
                parentFlag->second->left = node;
            }
            else
            {
                parentFlag->second->right = node;

                arrayOfNewNodes.erase(++parentFlag, arrayOfNewNodes.end());
            }

            if (arrayOfNewNodes.rbegin()->first - element.first >= 1)
            {
                arrayOfNewNodes.erase(++parentFlag, arrayOfNewNodes.end());
            }

            arrayOfNewNodes.emplace_back(std::pair<int, Node*>(element.first, node));
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

    for (int index = 0; index < nodesVector.size(); index++)
    {
        if (nodesVector[index]->right == nullptr
            && nodesVector[index]->left == nullptr
            && nodesVector.size() != index + 1)
        {
            nodesVector[index]->stitch = nodesVector[index + 1];
        }
    }
}

void ShowConnections(std::ostream &output, Node *tree)
{
    std::vector<Node*> nodesVector;
    bool isStitchedTree = false;
    FillStorageByStitchedNodes(nodesVector, tree);

    for (int index = 0; index < nodesVector.size() - 1; index++)
    {
        if (nodesVector[index]->stitch != nullptr)
        {
            isStitchedTree = true;
            output << nodesVector[index]->value << " - " << nodesVector[index + 1]->value << std::endl;
        }
    }

    if (!isStitchedTree)
    {
        output << "There are no stitched nodes" << std::endl;
    }
}

void ShowStitchedTree(std::ostream &output, Node *tree)
{
    Node* node = tree;

    while (node != nullptr)
    {
        output << node->value << std::endl;

        if (node->left != nullptr)
        {
            node = node->left;

            continue;
        }

        if (node->right != nullptr)
        {
            node = node->right;

            continue;
        }

        node = node->stitch;
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

void DeleteVertexByVertexValue(const int& value, Node*& topNode, bool& isVertexDeleted)
{
    if (topNode == nullptr || isVertexDeleted)
    {
        return;
    }

    if (topNode->value == value)
    {
        DeleteWholeTree(topNode);
        isVertexDeleted = true;

        return;
    }

    DeleteVertexByVertexValue(value, topNode->right, isVertexDeleted);
    DeleteVertexByVertexValue(value, topNode->left, isVertexDeleted);
}

void DeleteVertexByValue(int vertex, Node *tree)
{
    bool isVertexDeleted = false;

    DeleteVertexByVertexValue(vertex, tree, isVertexDeleted);
    Stitch(tree);
}

