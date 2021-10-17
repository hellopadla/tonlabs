pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract ToDoManager {
    
    struct task {
        string title;
        uint32 timestamp;
        bool flag;
    }

    int8 it = 0;

    mapping (int8 => task) public taskManager;

    constructor() public {
		// check that contract's public key is set
		require(tvm.pubkey() != 0, 101);
		// Check that message has signature (msg.pubkey() is not zero) and message is signed with the owner's private key
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
	}

	modifier checkOwnerAndAccept {
		// Check that message was signed with contracts key.
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
		_;
	}

    modifier checkMapEmpty {
        // проверка на пустой словарь
        require(!taskManager.empty(), 101);
        _;
    }

    function addTask(string name) public checkOwnerAndAccept {
        it++;
        task newTask = task(name, now, false);
        taskManager.add(it, newTask);
    }

    function openTasks() public checkOwnerAndAccept returns (int8) {
        // возвращает сумму заданий где bool == 0
        int8 sum = 0;
        for (int8 i = 1; i <= it; i++) {
            if (taskManager[i].flag == false) {
                sum++;
            }
        }
        return sum;
    }

    function listTasks() public checkOwnerAndAccept checkMapEmpty returns (string[]) {
        // вывод значений словаря через цикл
        string[] tasks;
        for (int8 i = 1; i <= it; i++) {
            tasks.push(taskManager[i].title);
        }
        return tasks;
    }

    function descriptionTask(int8 key) public checkOwnerAndAccept checkMapEmpty returns (task) {
        // вывод значения по ключу
        require((key >= 1) && (key <= it), 101);
        return taskManager[key];
    }

    function delTask(int8 key) public checkOwnerAndAccept checkMapEmpty {
        // удаления элемента по ключу
        require((key >= 1) && (key <= it), 101);
        delete taskManager[key];
    } 

    function doTask(int8 key) public checkOwnerAndAccept checkMapEmpty {
        // bool = 1 по ключу
        require((key >= 1) && (key <= it), 101);
        taskManager[key].flag = true;
    }
}
