# Distributed Objects

Instructor: JIM FAWCETT

-------------------------------------------------------------------------------
THIS SOFTWARE IS PROVIDED BY THE AUTHORS AND CONTRIBUTORS ``AS IS'' AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHORS OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
SUCH DAMAGE.
-------------------------------------------------------------------------------

TinyHttpServer is a lightweight web server implemented in C++11.
The aim is to give a simple example to demonstrate what 
C++11 has to offer.

TinyHttpServer project depends on the following source files:
```
gen_utils.cc	Collection of general purpose utilities
gen_utils.h	Declaration of collection of general purpose utilities
http_config.h   HTTP Server configuration file
http_mime.cc	Definition of MIME table
http_server.cc  Implementation of HTTP classes
http_server.h   Declaration of HTTP classes
os_dep.cc       Platform dependent code
os_dep.h        Platform dependent code
socket_utils.cc Implementation of socket classes containing 
                some useful stuff cross-platform for manipulating socket
socket_utils.h  Declaration of socket classes containing some useful stuff 
                cross-platform for manipulating socket 
```
```
makefile
    This is a makefile 
```

Below are the extensions made by Kai Li:
```
tiny_http_server.cc  add command-line options. (e.g., -a: bind to an IP, -r: 302 redirection)
http_server.cc       add HTTP methods handler, (e.g., DELETE, POST, PUT); add HTTP response codes. (e.g., 302 Found, 304 Not Modified)
gen_utils.cc         add time conversion (from string to mktime) and comparison functions, add md5 path anonimity feature.
```
Author: A. Calderone - acaldmail@gmail.com
Author: Kai Li - recarelee@gmail.com

-------------------------------------------------------------------------------
Testing
-------------------------------------------------------------------------------
1. Make
```bash
make
```

2. Preparation
```bash
mkdir -p /s3/tinyhttpbucket
touch /s3/tinyhttpbucket/d/15/index.html
touch /s3/tinyhttpbucket/d/40/delete.html
```

3. Run
```bash
sudo ./start.sh
```

4. start testing (open a new terminal)
```bash
cd ./demo
./demo_200.sh
./demo_304.sh
./demo_403.sh
./demo_404.sh
./demo_POST.sh (back to the terminal in step 3 to see server's output)
./demo_PUT.sh (back to the terminal in step 3 to see server's output)
./demo_HEAD.sh
./demo_DELETE.sh
```

5. To test 302 status code, go back to the terminal of step 3.
```bash
sudo ./stop.sh
sudo ./start.sh 1 (1 means enable redirect mode)
```
then open a new terminal and run the following command.
```bash
cd ./demo
./demo_302.sh
```
