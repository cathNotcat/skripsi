<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Default Database Connection Name
    |--------------------------------------------------------------------------
    |
    | Here you may specify which of the database connections below you wish
    | to use as your default connection for all database work. Of course
    | you may use many connections at once using the Database library.
    |
    */

    // 'default' => env('DB_CONNECTION', 'mysql'),
    'default' => env('DB_CONNECTION', 'SML'),

    /*
    |--------------------------------------------------------------------------
    | Database Connections
    |--------------------------------------------------------------------------
    |
    | Here are each of the database connections setup for your application.
    | Of course, examples of configuring each database platform that is
    | supported by Laravel is shown below to make development simple.
    |
    |
    | All database work in Laravel is done through the PHP PDO facilities
    | so make sure you have the driver for your particular database of
    | choice installed on your machine before you begin development.
    |
    */

    'connections' => [

        'connections' => [
            // Other connections...

            'sqlsrv' => [
                'driver' => 'sqlsrv',
                'host' => env('DB_HOST', 'localhost'),
                'port' => env('DB_PORT', '1433'),
                'database' => env('DB_DATABASE', 'forge'),
                'username' => env('DB_USERNAME', 'forge'),
                'password' => env('DB_PASSWORD', ''),
                'charset' => 'utf8',
                'prefix' => '',
                'schema' => 'dbo',
            ],

            // Other connections...
        ],


        // 'sqlsrv' => [
        //     'driver' => 'sqlsrv',
        //     'host' => '.',
        //     // 'host' => env('DB_HOST', '192.168.0.103'),
        //     'port' => '1433',
        //     'database' => 'DBSML',
        //     'username' => 'sa',
        //     'password' => 'Anekajc1a9',
        //     'unix_socket' => env('DB_SOCKET', ''),
        //     'charset' => 'utf8',
        //     // 'charset' => 'utf8mb4',
        //     // 'collation' => 'utf8mb4_unicode_ci',
        //     'prefix' => '',
        //     'strict' => true,
        //     'engine' => null,
        //     'modes' => [
        //         'STRICT_TRANS_TABLES',
        //         'NO_ZERO_IN_DATE',
        //         'NO_ZERO_DATE',
        //         'ERROR_FOR_DIVISION_BY_ZERO',
        //         'NO_AUTO_CREATE_USER',
        //         'NO_ENGINE_SUBSTITUTION'
        //     ],
        //
        // ],

        'sqlite' => [
            'driver' => 'sqlite',
            'database' => env('DB_DATABASE', database_path('database.sqlite')),
            'prefix' => '',
        ],

        'SPL' => [
            'driver' => 'sqlsrv',
            'host' => '.',
            'port' => '1433',
            'database' => 'DBSML',
            'username' => 'sa',
            'password' => 'Anekajc1a9',
            // 'charset' => 'utf8mb4',
            // 'collation' => 'utf8mb4_unicode_ci',
            'charset' => 'utf8',
            'prefix' => '',
            'strict' => true,
            'engine' => null,
            'modes' => [
                'STRICT_TRANS_TABLES',
                'NO_ZERO_IN_DATE',
                'NO_ZERO_DATE',
                'ERROR_FOR_DIVISION_BY_ZERO',
                'NO_AUTO_CREATE_USER',
                'NO_ENGINE_SUBSTITUTION'
            ],
        ],
        // PHSTK
        'SML' => [
            'driver' => 'sqlsrv',
            // 'host' => '103.144.220.202',
            'host' => '.',
            'port' => '1433',
            // 'database' => 'DBMAS',
            'database' => 'DBMAS_DUP',
            'username' => 'sa',
            // 'password' => 'IL%_eJV_8q',
            // 'username' => 'sa',
            // 'password' => 'anekajc1a9',
            'password' => 'Anekajc1a9',
            'charset' => 'utf8',
            'prefix' => '',
            'strict' => true,
            'engine' => null,
            // 'trust_server_certificate' => 'true',
            'modes' => [
                'STRICT_TRANS_TABLES',
                'NO_ZERO_IN_DATE',
                'NO_ZERO_DATE',
                'ERROR_FOR_DIVISION_BY_ZERO',
                'NO_AUTO_CREATE_USER',
                'NO_ENGINE_SUBSTITUTION'
            ],
        ],

        'SPLSIG' => [
            'driver' => 'sqlsrv',
            'host' => '.',
            'port' => '1433',
            // 'database' => 'DBPROJECT',
            'database' => 'DBSMLWEB',
            'username' => 'sa',
            'password' => 'Anekajc1a9',
            // 'charset' => 'utf8mb4',
            // 'collation' => 'utf8mb4_unicode_ci',
            'charset' => 'utf8',
            'prefix' => '',
            'strict' => true,
            'engine' => null,
            'modes' => [
                'STRICT_TRANS_TABLES',
                'NO_ZERO_IN_DATE',
                'NO_ZERO_DATE',
                'ERROR_FOR_DIVISION_BY_ZERO',
                'NO_AUTO_CREATE_USER',
                'NO_ENGINE_SUBSTITUTION'
            ],
        ],
    ],

    /*
    |--------------------------------------------------------------------------
    | Migration Repository Table
    |--------------------------------------------------------------------------
    |
    | This table keeps track of all the migrations that have already run for
    | your application. Using this information, we can determine which of
    | the migrations on disk haven't actually been run in the database.
    |
    */

    'migrations' => 'migrations',

    /*
    |--------------------------------------------------------------------------
    | Redis Databases
    |--------------------------------------------------------------------------
    |
    | Redis is an open source, fast, and advanced key-value store that also
    | provides a richer set of commands than a typical key-value systems
    | such as APC or Memcached. Laravel makes it easy to dig right in.
    |
    */

    'redis' => [

        'client' => 'predis',

        'default' => [
            'host' => env('REDIS_HOST', '127.0.0.1'),
            'password' => env('REDIS_PASSWORD', null),
            'port' => env('REDIS_PORT', 6379),
            'database' => 0,
        ],

    ],

];
