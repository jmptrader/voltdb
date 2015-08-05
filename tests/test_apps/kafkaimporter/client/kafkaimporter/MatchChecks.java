/* This file is part of VoltDB.
 * Copyright (C) 2008-2015 VoltDB Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
 * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

package kafkaimporter.client.kafkaimporter;

import java.io.IOException;

import org.voltcore.logging.VoltLogger;
import org.voltdb.VoltTable;
import org.voltdb.client.Client;
import org.voltdb.client.ClientResponse;
import org.voltdb.client.ProcCallException;
import org.voltdb.client.ProcedureCallback;

public class MatchChecks {
    static VoltLogger log = new VoltLogger("Benchmark.matchChecks");
    final static String DELETE_ROWS = "DeleteRows";

    static class DeleteCallback implements ProcedureCallback {
        final String proc;
        final long key;

        DeleteCallback(String proc, long key) {
            this.proc = proc;
            this.key = key;
        }

        @Override
        public void clientCallback(ClientResponse clientResponse) {

            // Make sure the procedure succeeded. If not,
            // report the error.
            if (clientResponse.getStatus() != ClientResponse.SUCCESS) {
                String msg = String.format("%s k: %12d, callback fault: %s", proc, key, clientResponse.getStatusString());
                log.error(msg);
              }
         }
    }

    protected static long getMirrorTableRowCount(Client client, String table) {
        // check row count in mirror table -- the "master" of what should come back
        // eventually via import
        long mirrorRowCount = 0;

        try {
            VoltTable[] countQueryResult = client.callProcedure(table).getResults();
            mirrorRowCount = countQueryResult[0].asScalarLong();
        } catch (IOException | ProcCallException e) {
            e.printStackTrace();
        }
        //log.info("Mirror table row count: " + mirrorRowCount);
        return mirrorRowCount;
    }

    public static long getImportTableRowCount(Client client, String table) {
        // check row count in import table
        long importRowCount = 0;
        try {
            VoltTable[] countQueryResult = client.callProcedure(table).getResults();
            importRowCount = countQueryResult[0].asScalarLong();
        } catch (IOException | ProcCallException e) {
            e.printStackTrace();
        }
        log.info("Import table row count: " + importRowCount);
        return importRowCount;
    }
}

