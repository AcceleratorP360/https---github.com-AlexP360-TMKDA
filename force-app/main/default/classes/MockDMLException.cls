public class MockDMLException extends Exception {
public void doMock() {
        throw new DMLException('DML exception');
    }
}