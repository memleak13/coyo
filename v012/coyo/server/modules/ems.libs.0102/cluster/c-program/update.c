
/*
**	Copyright (c) 2010 Itchigo Communications GmbH
**
**	Licensed under the Apache License, Version 2.0 (the "License");
**	you may not use this file except in compliance with the License.
**	You may obtain a copy of the License at
**
**		http://www.apache.org/licenses/LICENSE-2.0
**
**	Unless required by applicable law or agreed to in writing, software
**	distributed under the License is distributed on an "AS IS" BASIS,
**	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
**	See the License for the specific language governing permissions and
**	limitations under the License.
*/

#include <stdio.h>
#include <stdlib.h>

#define SPOOLDIR	"/var/spool/vamp/cluster"

static void checkASCII(const char *s, const char *info)
{
	if ((s == NULL) || (*s == 0)) {
		fprintf(stderr, "invalid %s\n", info);
		exit(1);
	}
	while (*s) {
		int c = *s++;
		if ((c < 0x20) || (c > 0x7e)) {
			fprintf(stderr, "invalid char in %s\n", info);
			exit(1);
		}
	}
}

static void checkLowerNum(const char *name, const char *info)
{
	if ((name == NULL) || (*name == 0)) {
		fprintf(stderr, "invalid %s\n", info);
		exit(1);
	}
	while (*name) {
		int c = *name++;
		if ((c < 0x30) || ((c > 0x39) && (c < 0x61)) || (c > 0x7a)) {
			fprintf(stderr, "invalid char in %s\n", info);
			exit(1);
		}
	}
}

static void printAttr(FILE *fp, const char *name, const char *value)
{
	if ((value == NULL) || (*value == 0))
		return;
	fprintf(fp, " %s=", name);
	fputc('"', fp);
	while (*value) {
		int c = *value++;
		if ((c < 0x20) || (c > 0x7e))
			c = 0x7e;
		if (c == '&') {
			fprintf(fp, "&amp;");
		} else if (c == '<') {
			fprintf(fp, "&lt;");
		} else {
			fputc(c, fp);
		}
	}
	fputc('"', fp);
}

int main(int argc, char **argv)
{

	if (argc != 6) {
		fprintf(stderr, "Usage: update cluster-name master-addr master-port auth-user auth-password\n");
		exit(1);
	}
	{
		const char *name = argv[1];
		const char *addr = argv[2];
		const char *port = argv[3];
		const char *user = argv[4];
		const char *password = argv[5];
		char filename[sizeof(SPOOLDIR)+20];
		char tmpname[sizeof(SPOOLDIR)+20];
		int fd;
		FILE *fp;

		checkLowerNum(name, "cluster-name");
		checkASCII(addr, "master-addr");
		checkASCII(port, "master-port");
		checkASCII(user, "auth-user");
		checkASCII(password, "auth-password");

		snprintf(filename, sizeof(filename), "%s/%s.xml", SPOOLDIR, name);
		snprintf(tmpname, sizeof(tmpname), "%s/%s.XXXXXXXX.tmp", SPOOLDIR, name);
		fd = mkstemps(tmpname, 4);
		if (fd == -1) {
			fprintf(stderr, "cannot create temporary file\n");
			exit(1);
		}

		fp = fdopen(fd, "w");
		fprintf(fp, "<cluster");
		printAttr(fp, "id", name);
		printAttr(fp, "master", addr);
		printAttr(fp, "port", port);
		printAttr(fp, "user", user);
		printAttr(fp, "password", password);
		printAttr(fp, "xmlns", "http://avenyo.com/cluster");
		fprintf(fp, " />\r\n");
		fclose(fp);

		if (rename(tmpname, filename) == -1) {
			fprintf(stderr, "cannot rename file\n");
			exit(1);
		}

		exit(0);
	}
}

