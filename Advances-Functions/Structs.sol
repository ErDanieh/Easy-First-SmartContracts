pragma solidity ^0.8.0;

contract TodoList {
    //Declare de structure
    struct TodoItem {
        string text;
        bool completed;
    }

    TodoItem[] public todos;

    function createTodo(string memory _text) public {
        //Method to initialize the structure
        todos.push(TodoItem(_text, false));

        //Method json with keys
        todos.push(TodoItem({text: _text, completed: false}));

        //Method 3 initialize empty, then set individual properties
        TodoItem memory todo;
        todo.text = _text;
        todo.completed = false;
        todos.push(todo);
    }

    function update(uint256 _index, string memory _text) public {
        todos[_index].text = _text;
    }

    function toggleCompleted(uint _index) public {
        todos[_index].completed = !todos[_index].completed;
    }
}
