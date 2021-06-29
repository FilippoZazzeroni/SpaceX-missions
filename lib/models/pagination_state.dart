enum PaginationState {
  suggestedSearchPage,
  loadingFirstPage,
  loadingMoreItems,
  firstPageError,

  /// It occours when the api respond with error when trying to load more items
  nextPageError,
  itemsFetched,
  noItmes,
}
