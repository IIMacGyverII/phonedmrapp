package com.macdmr.radio.ham;

import static org.junit.Assert.*;

import org.junit.Test;

import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.Random;

/** The bundled pools: sizes, exam layout (one question per group, as many groups as exam questions), figures present. */
public class ExamPoolTest {
    private static ExamPool load(String asset) throws Exception {
        return ExamPool.parse(new String(Files.readAllBytes(Paths.get("src/main/assets/" + asset)), StandardCharsets.UTF_8));
    }

    @Test public void poolsMatchTheExams() throws Exception {
        int[] sizes = { 409, 423, 599 };
        for (int i = 0; i < ExamPool.ELEMENTS.length; i++) {
            ExamPool.Element e = ExamPool.ELEMENTS[i];
            ExamPool p = load(e.asset);
            assertEquals(e.name, sizes[i], p.all.size());
            assertEquals(e.name + ": one group per exam question", e.questions, p.byGroup.size());
            List<ExamPool.Question> ex = p.exam(new Random(i));
            assertEquals(e.questions, ex.size());
            for (ExamPool.Question q : p.all) {
                assertEquals(q.id, 4, q.answers.length);
                assertTrue(q.id, q.correct >= 0 && q.correct < 4);
                if (!q.figure.isEmpty()) assertTrue("figure " + q.figure, Files.exists(Paths.get("src/main/assets/exam/" + q.figure)));
            }
        }
    }

    @Test public void subelements() throws Exception {
        ExamPool p = load("exam/technician-2026-2030.json");
        assertEquals(10, p.subelements().size());
        int sum = 0; for (int n : p.subelements().values()) sum += n;
        assertEquals(409, sum);
    }
}
