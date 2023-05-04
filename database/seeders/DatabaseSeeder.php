<?php

namespace Database\Seeders;

// use Illuminate\Database\Console\Seeds\WithoutModelEvents;

use App\Models\History;
use App\Models\User;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // \App\Models\User::factory(10)->create();

        // \App\Models\User::factory()->create([
        //     'name' => 'Test User',
        //     'email' => 'test@example.com',
        // ]);


        // User::create([
        //     'name' => 'Muhammad Azmi Fauzi',
        //     'email' => 'azmi@gmail.com',
        //     'password' => bcrypt("password"),
        // ]);

        History::create([
            'user_id' => '1',
            'type' => 'out',
            'date' => '12-12-12',
            'total' => '5000',
            'details' => 'Tahu Bulat',
        ]);
        History::create([
            'user_id' => '1',
            'type' => 'out',
            'date' => '12-12-12',
            'total' => '13000',
            'details' => 'Laptop',
        ]);
        History::create([
            'user_id' => '1',
            'type' => 'out',
            'date' => '12-12-12',
            'total' => '165000',
            'details' => 'Internet',
        ]);
    }
}
