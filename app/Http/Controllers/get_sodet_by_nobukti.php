<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\DB;

class get_sodet_by_nobukti extends Controller
{
    public function index()
    {
        return response()->json(['message' => 'API is working']);
    }

    public function getData($nobukti)
    {
        // $nobukti = urldecode($nobukti);
        $nobukti = str_replace('_', '/', $nobukti);

        $data = DB::connection('SML')->select(
            'SELECT KODEBRG, QNT FROM DBSODET
           WHERE NOBUKTI = :nobukti',
            ['nobukti' => $nobukti]
        );

        if (empty($data)) {
            return response()->json([
                'status' => 404,
                'message' => 'Data not found for the provided NOBUKTI',
                'data' => []
            ], 404);
        }


        $formattedData = [];
        foreach ($data as $item) {
            $formattedData[] = [
                'KODEBRG' => $item->KODEBRG,
                'QNT' => $item->QNT,
            ];
        }

        // Return the formatted response
        return response()->json([
            'status' => 200,
            'message' => 'Berhasil mengambil data',
            'data' => $formattedData
        ]);
    }
}
?>