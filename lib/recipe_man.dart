import 'package:flutter/material.dart';

void main() => runApp(RecipeApp());

class Recipe {
  String title;
  String description;

  Recipe({required this.title, required this.description});
}

class RecipeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Manager',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.green,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          elevation: 4,
          backgroundColor: Colors.green,
        ),
        cardTheme: CardTheme(
          elevation: 3,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      home: RecipeHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RecipeHomePage extends StatefulWidget {
  @override
  _RecipeHomePageState createState() => _RecipeHomePageState();
}

class _RecipeHomePageState extends State<RecipeHomePage> {
  List<Recipe> recipes = [];

  void _addRecipe() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeFormPage(
          onSave: (recipe) {
            setState(() {
              recipes.add(recipe);
            });
          },
        ),
      ),
    );
  }

  void _editRecipe(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeFormPage(
          recipe: recipes[index],
          onSave: (updatedRecipe) {
            setState(() {
              recipes[index] = updatedRecipe;
            });
          },
        ),
      ),
    );
  }

  void _deleteRecipe(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Recipe'),
        content: Text('Are you sure you want to delete this recipe?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                recipes.removeAt(index);
              });
              Navigator.pop(ctx);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeCard(int index) {
    final recipe = recipes[index];
    return Card(
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(
          recipe.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            recipe.description,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _editRecipe(index),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteRecipe(index),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Manager'),
      ),
      body: recipes.isEmpty
          ? Center(
              child: Text(
                'No recipes added yet.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            )
          : ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) => _buildRecipeCard(index),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addRecipe,
        child: Icon(Icons.add),
        tooltip: 'Add Recipe',
      ),
    );
  }
}

class RecipeFormPage extends StatefulWidget {
  final Recipe? recipe;
  final Function(Recipe) onSave;

  RecipeFormPage({this.recipe, required this.onSave});

  @override
  _RecipeFormPageState createState() => _RecipeFormPageState();
}

class _RecipeFormPageState extends State<RecipeFormPage> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;

  @override
  void initState() {
    super.initState();
    _title = widget.recipe?.title ?? '';
    _description = widget.recipe?.description ?? '';
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newRecipe = Recipe(title: _title, description: _description);
      widget.onSave(newRecipe);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.recipe != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Recipe' : 'Add Recipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _title,
                    decoration: InputDecoration(labelText: 'Recipe Title'),
                    validator: (value) =>
                        value!.isEmpty ? 'Enter a title' : null,
                    onSaved: (value) => _title = value!,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    initialValue: _description,
                    decoration: InputDecoration(labelText: 'Description'),
                    validator: (value) =>
                        value!.isEmpty ? 'Enter a description' : null,
                    onSaved: (value) => _description = value!,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isEditing ? 'Update Recipe' : 'Add Recipe',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
