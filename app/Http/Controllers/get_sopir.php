<?php


namespace App\Http\Controllers;

use Illuminate\Http\Request;
// use App\Model\NewMenu;
// use App\Model\NewAksesMenu;
// use App\Model\NewUsers;
use Illuminate\Support\Facades\DB;

class get_sopir extends Controller
{


    public function index()
    {
        // return view('tesApiCath');
        return response()->json(['message' => 'API is working']);
    }

    public function getData($kode)
    {
        $kodePattern = strtoupper($kode) . '%';

        $data = DB::connection('SML')->selectOne('
        SELECT kodesopir FROM DBSOPIR WHERE kodesopir LIKE :kode
      ', ['kode' => $kodePattern]);

        if ($data) {
            return response()->json([
                'status' => 200,
                'message' => 'Berhasil mengambil data',
                'data' => [
                    'kodesopir' => $data->kodesopir
                ]
            ]);
        } else {
            return response()->json([
                'status' => 404,
                'message' => 'Data not found',
            ]);
        }

        // $formattedData = [];

        // foreach ($listData as $item) {
        //     $formattedData[] = [
        //         'kodesopir' => $item->kodesopir,

        //     ];
        // }

        // return response()->json([
        //     'status' => 200,
        //     'message' => 'Berhasil mengambil data',
        //     'data' => $formattedData
        // ]);


    }
}
