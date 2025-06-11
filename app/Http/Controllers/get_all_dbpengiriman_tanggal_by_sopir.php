<?php


namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class get_all_dbpengiriman_tanggal_by_sopir extends Controller
{
    public function getData($sopir)
    {
        $listData = DB::connection('SML')->select(
            'SELECT 
            p.*, 
            c.Nama 
        FROM dbPengiriman p
        JOIN DBALAMATCUST c ON c.KODECUSTSUPP = p.KodeCustSupp
        WHERE p.KodeSopir = :sopir
        ORDER BY p.TanggalKirim DESC, p.NoPengiriman DESC, p.NoUrut ASC',
            ['sopir' => $sopir]
        );

        if (!$listData) {
            return response()->json([
                'status' => 404,
                'message' => 'Tidak ada data pengiriman',
            ], 404);
        }

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
                'KodeSopir' => $item->KodeSopir,
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
