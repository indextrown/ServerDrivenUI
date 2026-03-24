# 그냥 make 입력시 실행
.PHONY: all update
all: update
update:
	git add .
	git commit -m "update"
	git push origin main
