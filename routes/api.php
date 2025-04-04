<?php

use App\Http\Controllers\get_detail_nobukti_by_tanggal;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use App\Http\Controllers\post_upload_dbPengiriman;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:api')->get('/user', function (Request $request) {
    return $request->user();
});

// Route::get('/loadDataApi', 'tesApiCathController@loadData');
// Route::get('/spReport', 'tesApiCathController@spReport');

// SO
Route::get('/dbso', 'get_dbso@getData');
Route::get('/dbso/tanggal', 'get_all_nobukti_by_tanggal@getData');
Route::get('/dbso/tanggal/{tanggal}', [get_detail_nobukti_by_tanggal::class, 'getData']);
Route::get('/dbso/cust', 'get_kodecust_by_tanggalSO@getData');
Route::get('/dbso/detail/{nobukti}', [get_sodet_by_nobukti::class, 'getData']);

// CUST
Route::get('/customer/alamat/{kode}', [get_alamat_by_kodecust::class, 'getData']);
Route::get('/customer/alamat', 'get_all_alamat@getData');
Route::get('/sopir/{kode}', [get_sopir::class, 'getData']);

// DO
Route::get('/dbspp', 'get_all_dbspp@getData');
Route::get('/dbspp/tanggal', 'get_all_dbspp_by_tanggal@getData');

Route::post('/dbsppdet/nobukti', 'post_dbsppdet_nobukti@getDataByNOBUKTI');
Route::post('/dbspp/nobukti', 'post_dbspp_nobukti@getDataByNOBUKTI');

// Pengiriman
Route::post('/upload/pengiriman', 'post_upload_dbPengiriman@uploadDataPengiriman');
// Route::post('/pengiriman/delete', 'post_delete_pesanan@deleteData');
Route::post('/pengiriman/delete', [post_delete_pesanan::class, 'deleteData']);
Route::get('/pengiriman/tanggal/{tanggal}', [get_detail_dbpengiriman_by_tanggal::class, 'getData']);
Route::put('/pengiriman/update/{NoPengiriman}/{NoUrut}', [put_update_status_dbPengiriman::class, 'updateStatus']);




