// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  CartDao? _cartDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Cart` (`productId` INTEGER NOT NULL, `uid` TEXT NOT NULL, `name` TEXT NOT NULL, `imgUrl` TEXT NOT NULL, `size` TEXT NOT NULL, `code` TEXT NOT NULL, `price` REAL NOT NULL, `quantity` INTEGER NOT NULL, PRIMARY KEY (`productId`, `uid`, `size`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  CartDao get cartDao {
    return _cartDaoInstance ??= _$CartDao(database, changeListener);
  }
}

class _$CartDao extends CartDao {
  _$CartDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _cartInsertionAdapter = InsertionAdapter(
            database,
            'Cart',
            (Cart item) => <String, Object?>{
                  'productId': item.productId,
                  'uid': item.uid,
                  'name': item.name,
                  'imgUrl': item.imgUrl,
                  'size': item.size,
                  'code': item.code,
                  'price': item.price,
                  'quantity': item.quantity
                },
            changeListener),
        _cartUpdateAdapter = UpdateAdapter(
            database,
            'Cart',
            ['productId', 'uid', 'size'],
            (Cart item) => <String, Object?>{
                  'productId': item.productId,
                  'uid': item.uid,
                  'name': item.name,
                  'imgUrl': item.imgUrl,
                  'size': item.size,
                  'code': item.code,
                  'price': item.price,
                  'quantity': item.quantity
                },
            changeListener),
        _cartDeletionAdapter = DeletionAdapter(
            database,
            'Cart',
            ['productId', 'uid', 'size'],
            (Cart item) => <String, Object?>{
                  'productId': item.productId,
                  'uid': item.uid,
                  'name': item.name,
                  'imgUrl': item.imgUrl,
                  'size': item.size,
                  'code': item.code,
                  'price': item.price,
                  'quantity': item.quantity
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Cart> _cartInsertionAdapter;

  final UpdateAdapter<Cart> _cartUpdateAdapter;

  final DeletionAdapter<Cart> _cartDeletionAdapter;

  @override
  Stream<List<Cart>> getAllItemInCartByUid(String uid) {
    return _queryAdapter.queryListStream('SELECT * FROM Cart WHERE uid=?1',
        mapper: (Map<String, Object?> row) => Cart(
            row['productId'] as int,
            row['uid'] as String,
            row['name'] as String,
            row['imgUrl'] as String,
            row['size'] as String,
            row['code'] as String,
            row['price'] as double,
            row['quantity'] as int),
        arguments: [uid],
        queryableName: 'Cart',
        isView: false);
  }

  @override
  Future<List<Cart>> getItemInCartByUid(String uid, int id, String size) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Cart WHERE uid=?1 AND productId=?2 AND size=?3',
        mapper: (Map<String, Object?> row) => Cart(
            row['productId'] as int,
            row['uid'] as String,
            row['name'] as String,
            row['imgUrl'] as String,
            row['size'] as String,
            row['code'] as String,
            row['price'] as double,
            row['quantity'] as int),
        arguments: [uid, id, size]);
  }

  @override
  Future<List<Cart>> clearCartByUid(String uid) async {
    return _queryAdapter.queryList('DELETE FROM Cart WHERE uid=?1',
        mapper: (Map<String, Object?> row) => Cart(
            row['productId'] as int,
            row['uid'] as String,
            row['name'] as String,
            row['imgUrl'] as String,
            row['size'] as String,
            row['code'] as String,
            row['price'] as double,
            row['quantity'] as int),
        arguments: [uid]);
  }

  @override
  Future<void> updateUidCart(String uid) async {
    await _queryAdapter
        .queryNoReturn('UPDATE Cart SET uid=?1', arguments: [uid]);
  }

  @override
  Future<void> insertCart(Cart product) async {
    await _cartInsertionAdapter.insert(product, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateCart(Cart product) async {
    await _cartUpdateAdapter.update(product, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteCart(Cart product) async {
    await _cartDeletionAdapter.delete(product);
  }
}
