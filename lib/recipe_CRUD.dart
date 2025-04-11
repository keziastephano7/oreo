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
      ),
      home: RecipeHomePage(),
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
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(recipe.title),
        subtitle: Text(recipe.description),
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
        title: Text('Recipe Management System'),
      ),
      body: recipes.isEmpty
          ? Center(child: Text('No recipes added yet.'))
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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Recipe Title'),
                validator: (value) => value!.isEmpty ? 'Enter a title' : null,
                onSaved: (value) => _title = value!,
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) => value!.isEmpty ? 'Enter a description' : null,
                onSaved: (value) => _description = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(isEditing ? 'Update' : 'Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
