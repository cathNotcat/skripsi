<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\DB;

class get_detail_dbpengiriman_by_tanggal extends Controller
{
    public function index()
    {
        return response()->json(['message' => 'API is working']);
    }

    public function getData($tanggal)
    {
        $listData = DB::connection('SML')->select(
            'SELECT p.NoPengiriman, p.NoDO, a.Nama, p.KodeCustSupp, a.Alamat, a.Koordinat, p.Status, p.TanggalKirim, COUNT(s.NoBukti) AS JumlahBarang  
                    FROM dbPengiriman p
                    JOIN dbSPPDet s ON p.noDO = s.NoBukti
                    JOIN DBALAMATCUST a ON p.KodeCustSupp = a.KODECUSTSUPP 
                    WHERE CAST(TanggalKirim AS DATE) = :tanggal
                    GROUP BY p.NoPengiriman, p.noDO, p.kodecustsupp, p.Status, a.nama, a.alamat, a.koordinat, p.TanggalKirim
                    ORDER BY p.noDO;',
            ['tanggal' => $tanggal]
        );

        if (!$listData) {
            return response()->json([
                'status' => 200,
                'message' => 'No data found',
                'data' => []
            ], 200);
        }


        $formattedData = [];

        foreach ($listData as $item) {
            if (!isset($formattedData[$item->TanggalKirim])) {
                $formattedData[$item->TanggalKirim] = [
                    'NoPengiriman' => [],
                    'NoDO' => [],
                    'Nama' => [],
                    'KodeCustSupp' => [],
                    'Alamat' => [],
                    'Koordinat' => [],
                    'Status' => [],
                    'JumlahBarang' => [],
                ];
            }
            $formattedData[$item->TanggalKirim]['NoPengiriman'] = $item->NoPengiriman;
            $formattedData[$item->TanggalKirim]['NoDO'] = $item->NoDO;
            $formattedData[$item->TanggalKirim]['Nama'] = $item->Nama;
            $formattedData[$item->TanggalKirim]['KodeCustSupp'] = $item->KodeCustSupp;
            $formattedData[$item->TanggalKirim]['Alamat'] = $item->Alamat;
            $formattedData[$item->TanggalKirim]['Koordinat'] = $item->Koordinat;
            $formattedData[$item->TanggalKirim]['Status'] = $item->Status;
            $formattedData[$item->TanggalKirim]['JumlahBarang'] = $item->JumlahBarang;

        }

        $finalOutput = [];
        foreach ($formattedData as $tanggal => $data) {
            $finalOutput[] = [
                'NoPengiriman' => $data['NoPengiriman'],
                'TanggalKirim' => $tanggal,
                'NoDO' => $data['NoDO'],
                'Nama' => $data['Nama'],
                'KodeCustSupp' => $data['KodeCustSupp'],
                'Alamat' => $data['Alamat'],
                'Koordinat' => $data['Koordinat'],
                'Status' => $data['Status'],
                'JumlahBarang' => $data['JumlahBarang'],
            ];
        }





        // $formattedData = [
        //     'TanggalKirim' => $data[0]->TanggalKirim,
        //     'NoDO' => [],

        // ];

        // foreach ($data as $item) {
        //     $formattedData['NoDO'][] = $item->NoDO; // $item->NoDo (harus sama persis dengan db)
        // }

        return response()->json([
            'status' => 200,
            'message' => 'Berhasil mengambil data',
            'data' => $finalOutput
        ]);
    }
}
?>