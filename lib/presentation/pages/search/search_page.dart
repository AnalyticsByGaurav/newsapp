import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/search/search_bloc.dart';
import '../../blocs/search/search_event.dart';
import '../../blocs/search/search_state.dart';
import '../../widgets/article_card.dart';
import '../../widgets/empty_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<SearchBloc>().add(const SearchLoadMoreEvent());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'खोजें...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey[400]),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      context.read<SearchBloc>().add(const SearchClearEvent());
                    },
                  )
                : null,
          ),
          style: const TextStyle(fontSize: 16),
          onChanged: (q) => context.read<SearchBloc>().add(SearchQueryChangedEvent(q)),
        ),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchInitial) {
            return const AppEmptyWidget(
              message: 'समाचार खोजने के लिए टाइप करें',
              icon: Icons.search,
            );
          }
          if (state is SearchLoading) {
            return const ArticleListShimmer();
          }
          if (state is SearchEmpty) {
            return AppEmptyWidget(
              message: '"${state.query}" के लिए कोई परिणाम नहीं मिला',
              icon: Icons.search_off,
            );
          }
          if (state is SearchError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () => context.read<SearchBloc>().add(
                SearchQueryChangedEvent(_controller.text),
              ),
            );
          }
          if (state is SearchLoaded) {
            return ListView.builder(
              controller: _scrollController,
              itemCount: state.articles.length + (state.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.articles.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return ArticleCard(article: state.articles[index]);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
