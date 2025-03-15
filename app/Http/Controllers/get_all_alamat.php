<?php


namespace App\Http\Controllers;

use Illuminate\Http\Request;
// use App\Model\NewMenu;
// use App\Model\NewAksesMenu;
// use App\Model\NewUsers;
use Illuminate\Support\Facades\DB;

class get_all_alamat extends Controller
{


    public function index()
    {
        return response()->json(['message' => 'API is working']);
    }

    public function getData()
    {


        $listData = DB::connection('SML')->select('
          SELECT KODECUSTSUPP, ALAMAT, KOORDINAT
          FROM DBALAMATCUST
      ');

        $formattedData = [];

        foreach ($listData as $item) {
            $formattedData[] = [
                'KODECUSTSUPP' => $item->KODECUSTSUPP,
                'ALAMAT' => $item->ALAMAT,
                'KOORDINAT' => $item->KOORDINAT,
            ];
        }

        return response()->json([
            'status' => 200,
            'message' => 'Berhasil mengambil data',
            'data' => $formattedData
        ]);


    }
}
