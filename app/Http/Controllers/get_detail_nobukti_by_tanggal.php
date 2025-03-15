<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\DB;

class get_detail_nobukti_by_tanggal extends Controller
{
    public function index()
    {
        return response()->json(['message' => 'API is working']);
    }

    public function getData($tanggal)
    {


        $data = DB::connection('SML')->select(
            'SELECT * FROM DBMAS_DUP.dbo.DBSO 
            WHERE TANGGAL = :tanggal 
            ORDER BY TANGGAL DESC',
            ['tanggal' => $tanggal]
        );

        if (!$data) {
            return response()->json([
                'status' => 404,
                'message' => 'Data not found for the provided date',
                'data' => []
            ], 404);
        }

        $formattedData = [
            'TANGGAL' => $data[0]->TANGGAL,
            'NOBUKTI' => [],
        ];

        foreach ($data as $item) {
            $formattedData['NOBUKTI'][] = $item->NOBUKTI; // Add each NOBUKTI to the array
        }

        return response()->json([
            'status' => 200,
            'message' => 'Berhasil mengambil data',
            'data' => $formattedData
        ]);

        // if (empty($data)) {
        //     return response()->json([
        //         'status' => 404,
        //         'message' => 'Data not found for the provided date',
        //         'data' => []
        //     ], 404);
        // }

        // $formattedData = [];
        // foreach ($data as $item) {
        //     $formattedData[] = [
        //         'TANGGAL' => $item->TANGGAL,
        //         'NOBUKTI' => $item->NOBUKTI,
        //     ];
        // }

        // return response()->json([
        //     'status' => 200,
        //     'message' => 'Berhasil mengambil data',
        //     'data' => $formattedData
        // ]);
    }
}
?>