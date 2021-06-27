enum PaginationState {
  loadingFirstPage,
  loadingMoreItems,
  firstPageError,

  /// occours when the api respond with error when trying to load more items
  nextPageError,
  itemsFetched,
  noItmes,
}
