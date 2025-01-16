# Firestore To-Do App
This repository contains the implementation of a Flutter application that integrates Firebase Firestore to create a dynamic and real-time To-Do List. The app is designed to demonstrate various Firestore operations like querying, pagination, batch writes, transactions, and more, while ensuring a clean, reusable, and maintainable codebase.

## Features 

- **Real-Time Updates:** Task list updates in real-time using Firestore snapshots.
- **Pagination:** Implements efficient Firestore pagination for large datasets.
- **Firestore Batch Writes:** Add multiple tasks at once with a single Firestore operation.
- **Firestore Transactions:** Perform safe updates on task data using transactions.
- **Dynamic Data Handling:**  Fetches tasks dynamically and displays them with rich UI components.
- **Reusable Components:** Modular and reusable widgets to enhance code readability and scalability.
- **Error and Loading States:** Handles loading and error states gracefully.
- **Reusable Components:** Structured code with flexible and reusable components for maintainability.
- **Add, Update, Delete Tasks:**
  - Add tasks with a text input.
  - Update tasks safely using Firestore transactions.
  -Delete tasks with a single tap.  

## Installation

1. Clone the repository:
    ```bash
    git clone <repository_url>
    cd firestore-todo-app

    ```

2. Get the required dependencies:
    ```bash
    flutter pub get
    ```

3. Run the application:
    ```bash
    flutter run
    ```

## Folder Structure

The project follows the following structure:

```
lib/
├── main.dart                 # App entry point
├── screens/
│   ├── home_screen.dart      # Main screen with task list and input
├── services/
│   ├── firestore_service.dart # Firestore service for operations
├── widgets/
│   ├── task_input.dart       # Input field for adding tasks
│   ├── task_list.dart        # Displays task list with real-time updates

```

## Features Demonstrated
**1. QuerySnapshot & DocumentSnapshot**
      QuerySnapshot: Used to fetch tasks from Firestore in pages.
      DocumentSnapshot: Used for operations on individual tasks, like transactions or pagination.

**2. FutureBuilder & StreamBuilder**
      FutureBuilder: Fetches data once for pagination.
      StreamBuilder: Listens for real-time updates to tasks.

**3. Pagination**
Efficient pagination is implemented using Firestore’s startAfterDocument feature:
  ```dart

  query.startAfterDocument(_lastDocument!).limit(_pageSize);
  ```

**4. Batch Writes**
Batch writes allow adding multiple tasks in one operation:
  ```dart

  WriteBatch batch = _firestore.batch();
  batch.set(documentRef, data);
  batch.commit();
  ```

**5. Transactions**
Transactions ensure safe updates to Firestore documents:
  ```dart

  _firestore.runTransaction((transaction) async {
  DocumentSnapshot snapshot = await transaction.get(documentRef);
  transaction.update(documentRef, {'key': 'value'});
  });
 ```


## How to Use

1. **Setup the project:** Follow the installation steps to ensure the app runs successfully on an emulator or physical device.

2. **Run the app:** Use the following commands:
   ```bash
   flutter pub get
   flutter run
   ```

3. **Add a Task:** Enter a task in the text input field and press the add button.
4. **Update a Task:** Click the "Edit" button on a task to update its name.
5. **Delete a Task:** Long press on a task and confirm deletion.
6. **Batch Add Tasks:** Click the "Add Batch" button in the top-right corner.

## Future Improvements
- Add user authentication with Firebase Auth.
- Integrate push notifications for task reminders.
- Add support for task categories and priorities.
