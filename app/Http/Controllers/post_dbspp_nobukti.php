<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class post_dbspp_nobukti extends Controller
{
    public function getDataByNOBUKTI(Request $request)
    {
        $request->validate([
            'NOBUKTI' => 'required|string|max:255',
        ]);

        $nobukti = $request->input('NOBUKTI');

        if (empty($nobukti)) {
            return response()->json([
                'status' => 400,
                'message' => 'NOBUKTI field is required',
            ], 400);
        }


        $listData = DB::connection('SML')->selectOne('
            SELECT NoBukti, NoUrut, Tanggal, NoSHIP, NoPesan, KodeCustSupp
            FROM dbSPP
            WHERE NOBUKTI = ?
        ', [$nobukti]);

        if (!$listData) {
            return response()->json([
                'status' => 404,
                'message' => 'Data not found',
            ], 404);
        }


        $formattedData = [
            'NoBukti' => $listData->NoBukti,
            'NoUrut' => $listData->NoUrut,
            'Tanggal' => $listData->Tanggal,
            'NoSO' => $listData->NoSHIP,
            'NoPesan' => $listData->NoPesan,
            'KodeCustSupp' => $listData->KodeCustSupp,
        ];


        return response()->json([
            'status' => 200,
            'message' => 'Data retrieved successfully',
            'data' => $formattedData,
        ]);
    }
}
