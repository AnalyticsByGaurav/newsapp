import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/bookmarks/bookmarks_bloc.dart';
import '../../blocs/bookmarks/bookmarks_event.dart';
import '../../blocs/bookmarks/bookmarks_state.dart';
import '../../widgets/article_card.dart';
import '../../widgets/empty_widget.dart';

class BookmarksPage extends StatelessWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('बुकमार्क')),
      body: BlocBuilder<BookmarksBloc, BookmarksState>(
        builder: (context, state) {
          if (state is BookmarksLoaded) {
            if (state.bookmarks.isEmpty) {
              return const AppEmptyWidget(
                message: 'आपने कोई समाचार बुकमार्क नहीं किया है।\nसमाचार पढ़ते समय बुकमार्क आइकन दबाएं।',
                icon: Icons.bookmark_outline,
              );
            }
            return ListView.builder(
              itemCount: state.bookmarks.length,
              itemBuilder: (context, index) {
                final article = state.bookmarks[index];
                return Dismissible(
                  key: Key(article.slug),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    context.read<BookmarksBloc>().add(RemoveBookmarkEvent(article.slug));
                  },
                  child: Stack(
                    children: [
                      ArticleCard(article: article),
                      Positioned(
                        right: 4,
                        top: 4,
                        child: IconButton(
                          icon: const Icon(Icons.bookmark_remove_outlined, size: 20),
                          color: Colors.red[400],
                          tooltip: 'बुकमार्क हटाएं',
                          onPressed: () {
                            context.read<BookmarksBloc>().add(
                              RemoveBookmarkEvent(article.slug),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
