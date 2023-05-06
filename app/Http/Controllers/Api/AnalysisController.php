<?php

namespace App\Http\Controllers\Api;

use App\Helpers\ResponseFormatter;
use App\Http\Controllers\Controller;
use App\Models\History;
use Carbon\Carbon;
use Illuminate\Http\Request;

class AnalysisController extends Controller
{
    public function analytics(Request $request) 
    {
        date_default_timezone_set('Asia/Jakarta');
        $startDate = date_format(date_create(Carbon::now()->subDays(6)), 'Y-m-d') . " 00:00:00"; 
        $endDate = date_format(date_create(Carbon::now()), 'Y-m-d'). " 23:59:59";


        $pastSevenDays = History::whereBetween('created_at', [$startDate, $endDate])->where('user_id', $request->id)->get()
        ->where('type', 'Pengeluaran')
        ->groupBy(function ($item) {
            return $item->created_at->format('D');
        })->map(function($item) {
            return $item->sum('total');
        });

        $spentToday = History::whereBetween('created_at', [Carbon::today()->startOfDay(), Carbon::today()->endOfDay()])->where('user_id', $request->id)->get()->where('type', 'Pengeluaran')->sum('total');
        
        $spentYesterday = History::whereBetween('created_at', [Carbon::today()->subDays(1)->startOfDay(), Carbon::today()->subDays(1)->endOfDay()])->where('user_id', $request->id)->get()->where('type', 'Pengeluaran')->sum('total');

        $spentThisMonth = History::whereMonth('created_at', Carbon::now()->month)->where('user_id', $request->id)->get()->where('type', 'Pengeluaran')->sum('total');
        $incomeThisMonth = History::whereMonth('created_at', Carbon::now()->month)->where('user_id', $request->id)->get()->where('type', 'Pemasukan')->sum('total');

        return ResponseFormatter::success([
            'start_date' => $startDate,
            'end_date' => $endDate,
            'month_summary' => [
                'spentThisMonth' => $spentThisMonth,
                'incomeThisMonth' => $incomeThisMonth,
            ],
            'today' => History::where('user_id', $request->id)->whereDate('created_at', Carbon::today())->first() ?? History::where('user_id', $request->id)->orderBy('created_at', 'desc')->first(),
            'spent_today' => $spentToday,
            'spent_yesterday' => $spentYesterday,
            'past_seven_days' => [
                "keys" => array_keys($pastSevenDays->toArray()),
                "values" => array_values($pastSevenDays->toArray()),
            ],
        ]);
    }
}
