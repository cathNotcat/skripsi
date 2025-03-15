<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class post_dbsppdet_nobukti extends Controller
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

        $listData = DB::connection('SML')->select('
            SELECT KodeBrg, NamaBrg, QNT2, SAT_2, KetDetail
            FROM dbSPPDet
            WHERE NOBUKTI = ?
        ', [$nobukti]);

        if (empty($listData)) {
            return response()->json([
                'status' => 404,
                'message' => 'Data not found',
            ], 404);
        }

        // Format the response data
        $formattedData = [];
        foreach ($listData as $item) {
            $formattedData[] = [
                // 'NoBukti' => $item->NoBukti,
                'KodeBrg' => $item->KodeBrg,
                'NamaBrg' => $item->NamaBrg,
                'Quantity' => $item->QNT2,
                'Satuan' => $item->SAT_2,
                'Keterangan' => $item->KetDetail,
            ];
        }

        return response()->json([
            'status' => 200,
            'message' => 'Data retrieved successfully',
            'data' => $formattedData,
        ]);
    }
}
