﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _58TemSoru
{
    class OrnekSinif
    {
        int a;

        //public int Artir(int k, hangifonksyion)
        //{
        //    return k + 1;
        //}
    }


    class Program
    {
        static void Main(string[] args)
        {
            int k = 1;
            int m = 3;

            OrnekSinif o = new OrnekSinif();

            //k = o.Artir(k);
            //m = o.Artir(m);

        }

        int Fonksiyon1(int h)
        {
            return h--;
            Console.WriteLine("Birinci fonksiyon");
        }

        int Fonksiyon2(int h)
        {
            return h + 2;
            Console.WriteLine("İkinci fonksiyon");
        }
    }
}
