SET tusername=Bill
SET tpassword=Gates

docker build ^
--secret id=tusername ^
--secret id=tpassword ^
--progress=plain ^
-t cpp-linux-dev .
