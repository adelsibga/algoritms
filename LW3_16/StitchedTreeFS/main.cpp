#include "./lib/tree/Tree.h"
#include "./lib/tree_functions/TreeFunctions.h"
#include <iostream>

int main()
{
    std::cout << "Command <end> for closing the program" << std::endl
              << "Please, pass tree in follow way" << std::endl
              << "1\n-2\n--3\n--4\n---5\n-6\n#" << std::endl
              << "Pay attention, that symbol `#` is flag for ending tree" << std::endl;

    Tree tree = {};

    try
    {
        CreateTreeFromStream(std::cin, tree);

        std::cout << "All right! Now, pass  node for deleting" << std::endl;
        int desiredNodeForDeleting;
        std::string line;
        std::string number;

        std::cin >> line;
        do
        {
            std::istringstream ss(line);
            ss >> number;

            desiredNodeForDeleting = std::stoi(number);

            std::cout << "Tree in storage" << std::endl;
            ShowTree(std::cout, tree.top);
            Stitch(tree.top);
            std::cout << "Tree in stitched view" << std::endl;
            ShowStitchedTree(std::cout, tree.top);

            std::cout << "All stitches in tree nodes" << std::endl;
            ShowConnections(std::cout, tree.top);

            DeleteVertexByValue(desiredNodeForDeleting, tree.top);
            std::cout << "After deleting " << desiredNodeForDeleting << ":" << std::endl;
            ShowTree(std::cout, tree.top);

            std::cout << "Stitched nodes:" << std::endl;
            ShowConnections(std::cout, tree.top);
            std::cout << "Pass vertex for deleting again or just type command <end> to close the program" << std::endl;
        } while (std::cin >> line && line != "end");

        DeleteWholeTree(tree.top);
    }
    catch (const std::exception &exception)
    {
        std::cout << "Error: " << exception.what() << std::endl;
        return 1;
    }

    return 0;
}
