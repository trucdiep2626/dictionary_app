import 'package:dictionary_app/common/config/route/navigation_service.dart';
import 'package:dictionary_app/common/config/route/route_generator.dart';
import 'package:dictionary_app/presentations/screens/home/components/word_item.dart';
import 'package:dictionary_app/presentations/theme/theme_color.dart';
import 'package:dictionary_app/presentations/theme/theme_text.dart';
import 'package:dictionary_app/presentations/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dictionary_app/presentations/screens/home/home_state_notifier.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(homeNotifierProvider.notifier).initData();
    });
    scrollController = ScrollController()..addListener(scrollListener);
  }

  Future<void> scrollListener() async {
    if (!ref.watch(homeNotifierProvider).showLoadMoreIndicator &&
        !!!ref.watch(homeNotifierProvider).showLoadingIndicator &&
        scrollController.position.atEdge) {
      final isEnd = scrollController.position.pixels ==
          scrollController.position.maxScrollExtent;

      if (isEnd) {
        await ref.read(homeNotifierProvider.notifier).loadMore();
      }
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.blue,
        title: Text('Home Screen', style: ThemeText.bodyStrong.s20.white),
        actions: [
          GestureDetector(
            onTap: () async {
              final result =
                  await NavigationService.routeTo(RouteGenerator.addEditWord);
              if (result != null && result) {
                ref.read(homeNotifierProvider.notifier).initData();
              }
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.add,
                color: AppColors.white,
                size: 30,
              ),
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(homeNotifierProvider.notifier).initData(),
        child: SingleChildScrollView(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSearchBar(),
                const SizedBox(height: 16),
                _buildList(),
                if (state.showLoadMoreIndicator)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    final state = ref.watch(homeNotifierProvider);
    if (state.showLoadingIndicator) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (state.items.isEmpty && !state.showLoadingIndicator) {
      return const Center(
        child: Text('No data'),
      );
    } else {
      return _buildWordList();
    }
  }

  Widget _buildWordList() {
    final state = ref.watch(homeNotifierProvider);

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => WordItem(
        word: state.items[index],
        onRefresh: () {
          ref.read(homeNotifierProvider.notifier).initData();
        },
      ),
      separatorBuilder: (ctx, index) => const SizedBox(height: 16),
      itemCount: state.items.length,
    );
  }

  Widget _buildSearchBar() {
    final stateNotifier = ref.read(homeNotifierProvider.notifier);

    return AppTextField(
      prefixIcon: const Icon(Icons.search, color: AppColors.grey0_5),
      textInputAction: TextInputAction.search,
      hintText: 'Search',
      onEditingComplete: () {
        stateNotifier.searchWord();
      },
      controller: stateNotifier.searchController,
    );
  }
}
