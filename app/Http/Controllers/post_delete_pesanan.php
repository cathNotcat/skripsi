<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;


class post_delete_pesanan extends Controller
{
    public function deleteData(Request $request)
    {

        $noDO = $request->input('NoDO');
        $tanggalKirim = $request->input('TanggalKirim');

        $record = DB::connection('SML')
            ->table('dbPengiriman')
            ->where('NoDO', $noDO)
            ->whereDate('TanggalKirim', $tanggalKirim)
            ->first();

        if (!$record) {
            return response()->json([
                'status' => 404,
                'message' => 'Pesanan tidak ada di DB!',
                'NoDO' => $noDO,
                'TanggalKirim' => $tanggalKirim
            ], 404);
        }

        $deleted = DB::connection('SML')
            ->table('dbPengiriman')
            ->where('NoDO', $noDO)
            ->whereDate('TanggalKirim', $tanggalKirim)
            ->delete();

        return response()->json([
            'status' => 200,
            'message' => 'Pesanan berhasil dihapus!',
            'deleted_rows' => $deleted,
        ]);


        // try {
        //     $deleted = DB::connection('SML')
        //         ->table('dbPengiriman')
        //         ->where('NoDO', $request->input('NoDO'))
        //         ->whereDate('TanggalKirim', $request->input('TanggalKirim'))
        //         ->delete();

        //     if ($deleted) {
        //         return response()->json([
        //             'status' => 200,
        //             'message' => 'Data berhasil dihapus',
        //             'deleted_rows' => $deleted,
        //         ]);
        //     } else {
        //         return response()->json([
        //             'status' => 404,
        //             'message' => 'Data tidak ditemukan',
        //         ]);
        //     }
        // } catch (\Exception $e) {
        //     return response()->json([
        //         'status' => 500,
        //         'message' => 'Gagal menghapus data',
        //         'error' => $e->getMessage(),
        //     ], 500);
        // }
    }
}