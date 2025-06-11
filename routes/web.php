<?php

use App\Http\Controllers\post_user_admin;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/




// Route::get('/tesapicath', 'tesApiCathController@index');
// Route::get('/loadDataApi', 'tesApiCathController@loadData'); //Semisal mau ganti nama e, nde sini

// SO
Route::get('/dbso', 'get_dbso@getData');
Route::get('/dbso/tanggal', 'get_all_nobukti_by_tanggal@getData');
Route::get('/dbso/tanggal/{tanggal}', 'get_detail_nobukti_by_tanggal@getData');
Route::get('/dbso/cust', 'get_kodecust_by_tanggalSO@getData');
Route::get('/dbso/detail/{nobukti}', 'get_sodet_by_nobukti@getData');

// CUST
Route::get('/customer/alamat/{kode}', 'get_alamat_by_kodecust@getData');
Route::get('/customer/alamat', 'get_all_alamat@getData');
Route::get('/sopir/{kode}', 'get_sopir@getData');

// DO
Route::get('/dbspp', 'get_all_dbspp@getData');
Route::get('/dbspp/tanggal', 'get_all_dbspp_by_tanggal@getData');

Route::post('/dbsppdet/nobukti', 'post_dbsppdet_nobukti@getDataByNOBUKTI');
Route::post('/dbspp/nobukti', 'post_dbspp_nobukti@getDataByNOBUKTI');

// Pengiriman
Route::post('/upload/pengiriman', 'post_upload_dbPengiriman@uploadDataPengiriman');
Route::post('/pengiriman/delete', 'post_delete_pesanan@deleteData');
Route::get('/pengiriman/tanggal/{tanggal}', 'get_detail_dbpengiriman_by_tanggal@getData');
Route::get('/pengiriman/tanggal/sopir/{tanggal}/{sopir}', 'get_pengiriman_by_tanggal_sopir@getData');
Route::get('/pengiriman/tanggal', 'get_all_dbpengiriman_by_tanggal@getData');
Route::get('/pengiriman', 'get_all_dbpengiriman@getData');
Route::put('/pengiriman/update/{NoPengiriman}/{NoUrut}', 'put_update_status_dbPengiriman@updateStatus');

// Notif
Route::post('/notification/send', 'post_notification@sendNotification');

// User
Route::post('/user/admin', 'post_user_admin@getData');
Route::post('/user/sopir', 'post_user_sopir@getData');
Route::get('/sopir', 'get_all_sopir@getData');

// Ping
Route::get('/ping', function () {
    return response()->json(['status' => 'ok'], 200);
});
