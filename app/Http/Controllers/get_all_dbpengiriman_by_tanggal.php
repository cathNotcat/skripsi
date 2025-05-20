<?php


namespace App\Http\Controllers;

use Illuminate\Http\Request;
// use App\Model\NewMenu;
// use App\Model\NewAksesMenu;
// use App\Model\NewUsers;
use Illuminate\Support\Facades\DB;

class get_all_dbpengiriman_by_tanggal extends Controller
{


    public function index()
    {
        // return view('tesApiCath');
        return response()->json(['message' => 'API is working']);
    }

    public function getData()
    {
        $listData = DB::connection('SML')->select('
        SELECT 
            p.*, 
            c.Nama 
        FROM dbPengiriman p
        JOIN DBALAMATCUST c ON c.KODECUSTSUPP = p.KodeCustSupp
        ORDER BY p.TanggalKirim DESC, p.NoPengiriman DESC, p.NoUrut DESC
      ');

        $groupedData = [];

        foreach ($listData as $item) {
            $tanggal = \Carbon\Carbon::parse($item->TanggalKirim)->format('d-m-Y');

            if (!isset($groupedData[$tanggal])) {
                $groupedData[$tanggal] = [];
            }

            $groupedData[$tanggal][] = [
                'NoPengiriman' => $item->NoPengiriman,
                'NoDO' => $item->NoDO,
                'KodeCustSupp' => $item->KodeCustSupp,
                'Nama' => $item->Nama,
                'TanggalKirim' => $item->TanggalKirim,
                'Status' => $item->Status,
                'NoUrut' => $item->NoUrut,
                'SelesaiAt' => $item->SelesaiAt,
            ];
        }

        $finalOutput = [];
        foreach ($groupedData as $tanggal => $pengirimanList) {
            $finalOutput[] = [
                'TanggalKirim' => $tanggal,
                'Pengiriman' => $pengirimanList
            ];
        }

        return response()->json([
            'status' => 200,
            'message' => 'Berhasil mengambil data',
            'data' => $finalOutput
        ]);
    }
}
