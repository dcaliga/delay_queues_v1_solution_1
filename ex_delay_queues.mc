/* $Id: ex01.mc,v 2.1 2005/06/14 22:16:46 jls Exp $ */

/*
 * Copyright 2005 SRC Computers, Inc.  All Rights Reserved.
 *
 *	Manufactured in the United States of America.
 *
 * SRC Computers, Inc.
 * 4240 N Nevada Avenue
 * Colorado Springs, CO 80907
 * (v) (719) 262-0213
 * (f) (719) 262-0223
 *
 * No permission has been granted to distribute this software
 * without the express permission of SRC Computers, Inc.
 *
 * This program is distributed WITHOUT ANY WARRANTY OF ANY KIND.
 */

#include <libmap.h>

#define REF(_A,_i,_j) (_A[(_i)*SM+(_j)])


void subr (int64_t A[], int64_t B[], int SN, int SM, int num, int64_t *time, int mapnum) {


    OBM_BANK_A (AL, int64_t, MAX_OBM_SIZE)
    OBM_BANK_B (BL, int64_t, MAX_OBM_SIZE)

    uint8_t a00, a01, a02, a10, a11, a12, a20, a21, a22, px;

    int64_t t0, t1;
    int i,j;


    buffered_dma_cpu (CM2OBM, PATH_0, AL, MAP_OBM_stripe (1,"A"), A, 1, num*8);

    read_timer (&t0);

    for (i=0; i<SN-2; i++)  {
        for (j=0; j<SM; j++) {
        a20 = a21;
        a21 = a22;
        a22 = REF (AL, i+2, j);

        a10 = a11;
        a11 = a12;
        a12 = REF (AL, i+1, j);

        a00 = a01;
        a01 = a02;
        a02 = REF (AL, i, j);

        median_8_9 (a00, a01, a02, a10, a11, a12, a20, a21, a22, &px);

        if (j>=2)
        REF (BL, i, j-2) = px;
        }
     }

    read_timer (&t1);

    *time = t1 - t0;

    buffered_dma_cpu (OBM2CM, PATH_0, BL, MAP_OBM_stripe (1,"B"), B, 1, num*8);

}
