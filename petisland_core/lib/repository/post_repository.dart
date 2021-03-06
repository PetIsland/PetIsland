part of petisland_core.repository;

abstract class PostRepository {
  Future<Post> create(PostCreateModal postModal);

  Future<Post> like(String id);

  Future<List<Item>> getPosts(
      int offset, int limit, String categoryType, String petCategoryId);

  Future<Post> delete(String id);

  Future<Post> edit(PostEditModal postModal);

  Future<Comment> createComment(String postId, String message);

  Future<List<Comment>> getComments(String postId, {int offset, int limit});

  Future<Comment> deleteComment(String postId, String commentId);

  Future<List<PanelDetail>> getMyPost({int offset, int limit});

  Future<List<PanelDetail>> getFavoritePosts({int offset, int limit});

  Future<Post> getPost(String id);
}

class PostRepositoryImpl extends PostRepository {
  final HttpClient client;

  PostRepositoryImpl(this.client);

  @override
  Future<Post> create(PostCreateModal postModal) {
    return client
        .post<Map<String, dynamic>>('/api/post', postModal.toJson())
        .then((Map<String, dynamic> json) => Post.fromJson(json));
  }

  @override
  Future<Post> like(String id) {
    return client
        .get<Map<String, dynamic>>('/api/post/$id/react')
        .then((Map<String, dynamic> json) => Post.fromJson(json));
  }

  @override
  Future<List<Item>> getPosts(
      int offset, int limit, String categoryType, String petCategoryId) {
    final Map<String, dynamic> params = <String, dynamic>{
      'offset': offset,
      'limit': limit,
      'category': categoryType,
      'petCategoryId': petCategoryId
    }..removeWhere((_, dynamic value) => value == null);

    Log.debug(params);

    return client
        .get<List<dynamic>>('/api/post', params: params)
        .then(_parseToListItem);
  }

  @override
  Future<List<PanelDetail>> getMyPost({int offset, int limit}) {
    final params = {'offset': offset ?? 0, 'limit': limit ?? 15};
    return client
        .get<List>('/api/post/list/by-account', params: params)
        .then(_parseToListPostItem);
  }

  @override
  Future<List<PanelDetail>> getFavoritePosts({int offset, int limit}) {
    final params = {'offset': offset ?? 0, 'limit': limit ?? 15};

    return client
        .get<List>('/api/post/list/liked-by-account', params: params)
        .then(_parseToListPostItem);
  }

  List<PanelDetail> _parseToListPostItem(List<dynamic> jsons) {
    return jsons
        .cast<Map<String, dynamic>>()
        .map((Map<String, dynamic> json) => _parseToPost(json))
        .where((Item item) => item != null)
        .cast<PanelDetail>()
        .toList();
  }

  List<Item> _parseToListItem(List<dynamic> jsons) {
    return jsons
        .cast<Map<String, dynamic>>()
        .map((Map<String, dynamic> json) => _parseToPost(json))
        .where((Item item) => item != null)
        .toList();
  }

  Item _parseToPost(Map<String, dynamic> json) {
    final String type = json['type'];
    Item item;
    if (type == null)
      item = null;
    else {
      if (compareString(type, 'post'))
        item = PanelDetail.fromJson(json);
      else
        item = Panel.fromJson(json);
    }
    return item;
  }

  @override
  Future<Post> delete(String id) {
    return client.delete('/api/post/$id').then((_) => Post.fromJson(_));
  }

  @override
  Future<Post> edit(PostEditModal postModal) {
    final id = postModal.id;
    final body = postModal.toJson();
    return client.put('/api/post/$id', body).then((_) => Post.fromJson(_));
  }

  @override
  Future<Comment> createComment(String postId, String message) {
    final Map<String, String> map = {'message': message};
    return client
        .post('/api/post/$postId/comment', map)
        .then((_) => Comment.fromJson(_));
  }

  @override
  Future<Comment> deleteComment(String postId, String commentId) {
    return client
        .delete('/api/post/$postId/comment/$commentId')
        .then((_) => Comment.fromJson(_));
  }

  @override
  Future<List<Comment>> getComments(String postId,
      {int offset = 0, int limit = 15}) {
    return client
        .get<List<dynamic>>('/api/post/$postId/comment')
        .then((_) => _parseToComments(_));
  }

  List<Comment> _parseToComments(List<dynamic> list) {
    return list
        .cast<Map<String, dynamic>>()
        .map((json) => Comment.fromJson(json))
        .toList();
  }

  @override
  Future<Post> getPost(String id) {
    return client
        .get<Map<String, dynamic>>('/api/post/$id')
        .then((json) => Post.fromJson(json));
  }
}
