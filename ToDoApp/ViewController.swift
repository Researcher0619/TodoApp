//  ViewController.swift
//  ToDoApp
//
//  Created by Özkan CEYHAN on 19.11.2024.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Array to store the tasks
    var tasks: [String] = []
    
    // Index of the selected task (for editing purposes)
    var selectedTaskIndex: Int?
    
    // Outlets for the task input field and the table view
    @IBOutlet var taskTextField: UITextField!
    @IBOutlet var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setting the data source and delegate for the table view
        tableview.dataSource = self
        tableview.delegate = self
        
        // Loading the saved tasks from UserDefaults
        loadTasks()
    }

    // Function to add or update a task
    @IBAction func addTask(_ sender: Any) {
        // Check if the task input field is not empty
        if let task = taskTextField.text, !task.isEmpty {
            if let selectedIndex = selectedTaskIndex {
                // Update the existing task
                tasks[selectedIndex] = task
                
                // Reset the selected task index after updating
                selectedTaskIndex = nil
            } else {
                // Add a new task to the tasks array
                tasks.append(task)
            }

            // Reload the table view to display the updated tasks list
            tableview.reloadData()
            
            // Clear the task input field
            taskTextField.text = ""
            
            // Save the updated tasks list to UserDefaults
            saveTasks()

        } else {
            // Show an alert if the task input field is empty
            showAlert(message: "Please enter a task!")
        }
    }
    
    // Function to save tasks to UserDefaults
    func saveTasks() {
        UserDefaults.standard.set(tasks, forKey: "savedTasks")
    }
    
    // Function to load tasks from UserDefaults
    func loadTasks() {
        // Retrieve the saved tasks from UserDefaults
        if let savedTasks = UserDefaults.standard.array(forKey: "savedTasks") as? [String] {
            tasks = savedTasks
        }
    }

    // Function to show an alert when the input is invalid
    func showAlert(message: String) {
        // Creating UIAlertController
        let alert = UIAlertController(title: "Invalid Input!", message: message, preferredStyle: .alert)
        
        // Adding OK button
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        // Display the alert
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table View Data Source Methods
    
    // Return the number of rows in the table view (equal to the number of tasks)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    // Configure each cell with the task name
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Reuse an existing cell or create a new one
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        
        // Set the task text for each row
        cell.textLabel?.text = tasks[indexPath.row]
        
        return cell
    }
    
    // Function to delete a task when the user swipes to delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove the task from the tasks array
            tasks.remove(at: indexPath.row)
            
            // Remove the row from the table view
            tableview.deleteRows(at: [indexPath], with: .fade)
            
            // Save the updated tasks list to UserDefaults
            saveTasks()
        }
    }
    
    // Function to handle selecting a task (for editing)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Store the index of the selected task for later editing
        selectedTaskIndex = indexPath.row
        
        // Display the selected task in the input field
        taskTextField.text = tasks[selectedTaskIndex!]
    }
}
