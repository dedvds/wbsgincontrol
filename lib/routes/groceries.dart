import 'package:todonotes/services/groceries.dart';
import 'package:todonotes/utilities.dart';
import 'package:flutter/material.dart';

import '../entities/grocery.dart';
import '../services/auth.dart';
import '../widgets/grocery_list_tile.dart';

class Groceries extends StatefulWidget {
  const Groceries({Key? key}) : super(key: key);

  @override
  State<Groceries> createState() => _GroceriesState();
}

class _GroceriesState extends State<Groceries> {
  final authService = AuthService();
  final groceriesService = GroceriesService();
  bool isLoading = true;
  final inputController = TextEditingController();

  List<Grocery> groceries = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchGroceries();
    });
  }

  void fetchGroceries() async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final result = await groceriesService.fetch();
      setState(() {
        groceries = result;
      });
    } catch (e) {
      messenger.showSnackBar(createErrorSnackBar(e.toString()));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void submitGrocery() async {
    if (inputController.text.isEmpty || isLoading) return;
    final messenger = ScaffoldMessenger.of(context);
    try {
      final newGrocery = await groceriesService.create(content: inputController.text);
      inputController.text = '';
      setState(() {
        groceries.add(newGrocery);
      });
    } catch (e) {
      messenger.showSnackBar(createErrorSnackBar(e.toString()));
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final headlineStyle = Theme.of(context).textTheme.displaySmall?.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        );

    const spacing = 10.0;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            bottom: spacing,
            right: spacing,
            child: Row(
              children: [
                OutlinedButton(
                    onPressed: () async {
                      final navigator = Navigator.of(context);
                      final messenger = ScaffoldMessenger.of(context);
                      try {
                        await authService.logout();
                        navigator.pop();
                      } catch (e) {
                        messenger
                            .showSnackBar(createErrorSnackBar(e.toString()));
                      }
                    },
                    child: const Text("Logout 👋"))
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon( Icons.local_grocery_store, size: 50),
              const SizedBox(height: spacing),
              Center(
                child: Text(
                  "Groceries",
                  style: headlineStyle,
                ),
              ),
              const SizedBox(height: spacing),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: spacing * 2),
                child: Material(
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                  elevation: 5,
                  child: TextField(
                    controller: inputController,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (value) {
                      submitGrocery();
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: const OutlineInputBorder(),
                      hintText: '🤔   Need some stuff?',
                      contentPadding: const EdgeInsets.only(left: 20),
                      suffixIcon: IconButton(
                        onPressed: submitGrocery,
                        icon: const Icon(Icons.add),
                      ),
                    ),
                  ),
                ),
              ),
              // if (isLoading)
              //   const Padding(
              //     padding: EdgeInsets.only(top: spacing * 2),
              //     child: Text('Loading ....'),
              //   ),
              if (groceries.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: spacing * 2),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: groceries.length,
                    prototypeItem: GroceryListTile(grocery: groceries.first),
                    itemBuilder: (context, index) {
                      return GroceryListTile(
                        grocery: groceries[index],
                        toggle: () async {
                          setState(() {
                            isLoading = true;
                          });
                          final messenger = ScaffoldMessenger.of(context);
                          groceries[index].isComplete = !groceries[index].isComplete;
                          try {
                            final updated =
                                await groceriesService.update(grocery: groceries[index]);
                            setState(() {
                              groceries[index] = updated;
                            });
                          } catch (e) {
                            // restore value
                            groceries[index].isComplete = !groceries[index].isComplete;
                            messenger.showSnackBar(
                                createErrorSnackBar(e.toString()));
                          } finally {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                        delete: () async {
                          setState(() {
                            isLoading = true;
                          });
                          final messenger = ScaffoldMessenger.of(context);
                          try {
                            await groceriesService.delete(id: groceries[index].id);
                            setState(() {
                              groceries.removeAt(index);
                            });
                          } catch (e) {
                            // restore value
                            groceries[index].isComplete = !groceries[index].isComplete;
                            messenger.showSnackBar(
                                createErrorSnackBar(e.toString()));
                          } finally {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
