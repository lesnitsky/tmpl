extension NestedKeys<T, K> on Map<T, K> {
  K nested(String key) {
    final chunks = key.split('.');
    dynamic d = this;

    while (chunks.length > 0 && chunks[0].length > 0) {
      var k = chunks.removeAt(0);
      d = d[k];
    }

    return d;
  }
}
