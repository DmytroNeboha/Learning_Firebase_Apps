//
//  ViewController.swift
//  FirebaseTodo
//
//  Created by Dmytro Neboha on 15.03.2023.
//

import UIKit

class ViewController: UITableViewController {
    
    var todoItems = [TodoItem]() {
        didSet {
            print("todo items was set")
            tableView.reloadData()
        }
    }
    
    let reuseIdentifier = "TodoCell"
    
    lazy var createNewButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.backgroundColor = UIColor(red: 252/255, green: 163/255, blue: 17/255, alpha: 1.0)
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        button.addTarget(self, action: #selector(createNewTodo), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
        fetchItems()
        
        navigationItem.title = "My Todos"
    }
    
    // MARK: - Selectors
    
    @objc func createNewTodo() {
        let vc = CreateTodoController()
        present(vc, animated: true, completion: nil)
    }
    
    @objc func handleRefresh() {
        self.tableView.refreshControl?.beginRefreshing()
        
        if let isRefreshing = self.tableView.refreshControl?.isRefreshing, isRefreshing {
            DispatchQueue.main.async { [self] in
                fetchItems()
                tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    // MARK: - API
    
    private func fetchItems() {
        PostService.shared.fetchAllItems { (allItems) in
            self.todoItems = allItems
        }
    }
    
    // MARK: - Helper Function
    
    func configureTableView() {
        tableView.backgroundColor = UIColor(red: 20/255, green: 33/255, blue: 61/255, alpha: 1.0)
        tableView.register(TodoCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 75
        tableView.separatorColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        tableView.tableFooterView = UIView()
        
    
        // Refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .systemGreen
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        
        // Create new todo button
        tableView.addSubview(createNewButton)
        createNewButton.anchor(bottom: tableView.safeAreaLayoutGuide.bottomAnchor, right: tableView.safeAreaLayoutGuide.rightAnchor,
                               paddingBottom: 16, paddingRight: 16, width: 56, height: 56)
        createNewButton.layer.cornerRadius = 56 / 2
        createNewButton.alpha = 1
    }

    
}


extension ViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? TodoCell else {
            return UITableViewCell()
        }
        
        cell.todoItem = todoItems[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let todoItem = todoItems[indexPath.row]
        
        PostService.shared.updateItemStatus(todoId: todoItem.id, isComplete: true) { (err, ref) in
            print("Complete")
            self.tableView.deselectRow(at: indexPath, animated: true)
            self.fetchItems()
        }
    }
}
