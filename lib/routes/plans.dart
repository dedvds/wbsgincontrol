import 'package:todonotes/utilities.dart';
import 'package:flutter/material.dart';

import '../entities/plan.dart';
import '../services/auth.dart';
import '../services/plans.dart';
import '../widgets/plan_list_tile.dart';

class Plans extends StatefulWidget {
  const Plans({Key? key}) : super(key: key);

  @override
  State<Plans> createState() => _PlansState();
}

class _PlansState extends State<Plans> {
  final authService = AuthService();
  final plansService = PlansService();
  bool isLoading = true;
  final inputController = TextEditingController();

  List<Plan> plans = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchPlans();
    });
  }

  void fetchPlans() async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final result = await plansService.fetch();
      setState(() {
        plans = result;
      });
    } catch (e) {
      messenger.showSnackBar(createErrorSnackBar(e.toString()));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void submitPlan() async {
    if (inputController.text.isEmpty || isLoading) return;
    final messenger = ScaffoldMessenger.of(context);
    try {
      final newPlan = await plansService.create(content: inputController.text);
      inputController.text = '';
      setState(() {
        plans.add(newPlan);
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
              const Icon( Icons.rocket, size: 50),
              const SizedBox(height: spacing),
              Center(
                child: Text(
                  "Plans",
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
                      submitPlan();
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: const OutlineInputBorder(),
                      hintText: '🤔   Got a new plan?',
                      contentPadding: const EdgeInsets.only(left: 20),
                      suffixIcon: IconButton(
                        onPressed: submitPlan,
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
              if (plans.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: spacing * 2),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: plans.length,
                    prototypeItem: PlanListTile(plan: plans.first),
                    itemBuilder: (context, index) {
                      return PlanListTile(
                        plan: plans[index],
                        toggle: () async {
                          setState(() {
                            isLoading = true;
                          });
                          final messenger = ScaffoldMessenger.of(context);
                          plans[index].isComplete = !plans[index].isComplete;
                          try {
                            final updated =
                                await plansService.update(plan: plans[index]);
                            setState(() {
                              plans[index] = updated;
                            });
                          } catch (e) {
                            // restore value
                            plans[index].isComplete = !plans[index].isComplete;
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
                            await plansService.delete(id: plans[index].id);
                            setState(() {
                              plans.removeAt(index);
                            });
                          } catch (e) {
                            // restore value
                            plans[index].isComplete = !plans[index].isComplete;
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
