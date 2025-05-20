<?php


namespace App\Http\Controllers;

use Illuminate\Http\Request;
// use App\Model\NewMenu;
// use App\Model\NewAksesMenu;
// use App\Model\NewUsers;
use Illuminate\Support\Facades\DB;

class get_all_dbpengiriman extends Controller
{


    public function index()
    {
        // return view('tesApiCath');
        return response()->json(['message' => 'API is working']);
    }

    public function getData()
    {
        $listData = DB::connection('SML')->select('
            SELECT * FROM dbPengiriman p
            JOIN DBALAMATCUST c ON c.KODECUSTSUPP = p.KodeCustSupp
            ORDER BY NoPengiriman DESC, NoUrut DESC');
        //   SELECT * FROM dbPengiriman ORDER BY NoPengiriman DESC, NoUrut DESC');

        $formattedData = [];

        foreach ($listData as $item) {
            $formattedData[] = [
                'NoPengiriman' => $item->NoPengiriman,
                'NoDO' => $item->NoDO,
                'KodeSopir' => $item->KodeSopir,
                'KodeCustSupp' => $item->KodeCustSupp,
                'NamaCust' => $item->Nama,
                'TanggalKirim' => $item->TanggalKirim,
                'Status' => $item->Status,
                'NoUrut' => $item->NoUrut,
                'SelesaiAt' => $item->SelesaiAt,
            ];
        }

        return response()->json([
            'status' => 200,
            'message' => 'Berhasil mengambil data',
            'data' => $formattedData
        ]);
    }
}
